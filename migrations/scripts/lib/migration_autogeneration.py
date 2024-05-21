from pathlib import Path
from typing import Any, Dict, List, Optional

from jinja2 import (
    Environment,
    FileSystemLoader,
    TemplateRuntimeError,
    select_autoescape,
)

from .config import SourceDataConfig
from .migration_state import MigrationState, MigrationTableDiff


def _mandatory_columns(input: List[Dict[str, Any]], columns: List[str] = []):
    """Checks if mandatory columns are present.
    If a column is missing a TemplateRuntimeError is raised.

    input: List of column definitions. Each dict should have a "name" key with the column name
    columns: List of mandatory columns to check for
    """
    input_columns = {c["name"] for c in input}
    for mandatory_column in columns:
        if mandatory_column not in input_columns:
            raise TemplateRuntimeError(
                f"One or more mandatory columns are missing. Make sure the following columns are in the configuration: {columns} vs. {input_columns}"
            )
    return input


def _find_column(input: List[List[Dict[str, Any]]], column_name: Optional[str] = None):
    """Extracts the column with `column_name` from the input.
    If there is no column with that name a TemplateRuntimeError is raised.

    input: List of column definitions. Each dict should have a "name" key with the column name
    column_name: Name of the column that should be extracted from the input
    """
    for c in input:
        if c["name"] == column_name:
            return c
    raise TemplateRuntimeError(f"No column {column_name} found in input")


def _unwrap_macros(input: str) -> str:
    """Detects if the input is a jinja macro (starts with {{ xyz }}).
    If the input is a macro, the macro without the curly brakets will be returned.
    Otherwise the input is returned with added double-quotes.
    """
    if input.startswith("{{"):
        return input.replace("{{ ", "").replace(" }}", "")
    else:
        return f'"{input}"'


def _escape_keywords(input: str) -> str:
    if input in {"order", "current"}:
        return f'"{input}"'
    return input


def get_jinja_env(loader_path: Path) -> Environment:
    env = Environment(
        loader=FileSystemLoader(loader_path), autoescape=select_autoescape()
    )
    env.filters["mandatory_columns"] = _mandatory_columns
    env.filters["find_column"] = _find_column
    env.filters["unwrap_macros"] = _unwrap_macros
    env.filters["escape_keywords"] = _escape_keywords
    return env


def get_diff_text(table_name: str, diff: MigrationTableDiff):
    if diff.has_changed():
        return f"""\
-- Name: {table_name}
-- Added: {diff.added_columns}
-- Deleted: {diff.deleted_columns}
-- Changed: {diff.changed_columns}
""" + (
            f"-- Changed File Name: {diff.changed_filename}"
            if diff.changed_filename
            else ""
        )
    else:
        return None


def generate_merge_query(
    state: MigrationState,
    env: Environment,
    output_dir: Path,
    config: SourceDataConfig,
    merge_query_template: Optional[str] = None,
):
    table_name = config.target.table_name
    # Update merge query directly
    merge_output = (
        output_dir / f"R__{config.target.schema}_{table_name}_merge_query.sql.jinja"
    )
    if config.target.generate_merge_query and merge_query_template:
        merge_template = env.get_template(merge_query_template)
        merge_output.write_text(
            merge_template.render(**config.to_jinja_context()).strip() + "\n"
        )
    else:
        diff = state.get_table_diff(table_name, config)
        diff_text = get_diff_text(table_name, diff)
        if diff_text:
            if merge_output.exists():
                new_merge_query = merge_output.read_text()
            else:
                new_merge_query = ""
            new_merge_query = (
                "-- TODO: Update merge query\n" + diff_text + "\n" + new_merge_query
            )
            merge_output.write_text(new_merge_query)


def generate_migration(
    state: MigrationState,
    env: Environment,
    output_dir: Path,
    config: SourceDataConfig,
    migration_template: Optional[str] = None,
    add_column_migration_template: Optional[str] = None,
):
    table_name = config.target.table_name
    migration_version = state.get_migration_version()
    migration_output = (
        output_dir
        / f"V{migration_version}__{config.target.schema}_{table_name}.sql.jinja"
    )
    if config.target.generate_migrations and migration_template and not state.table_exists(table_name):
        create_template = env.get_template(migration_template)
        migration_output.write_text(
            create_template.render(**config.to_jinja_context()).strip() + "\n"
        )
    else:
        diff = state.get_table_diff(table_name, config)
        if diff.has_changed():
            needs_manual_migration = (
                len(diff.changed_columns) > 0
                or len(diff.deleted_columns) > 0
                or diff.changed_filename
            )

            if (
                not add_column_migration_template
                or not config.target.generate_migrations
                or needs_manual_migration
            ):
                # Can't autogenerate migration
                diff_text = get_diff_text(table_name, diff)
                migration_output.write_text(
                    "-- TODO: Add table migration here\n" + diff_text
                )
            else:
                # Only adding columns + we have a template for that
                add_template = env.get_template(add_column_migration_template)
                migration_output.write_text(
                    add_template.render(
                        table_name=table_name, add_columns=diff.added_columns
                    ).strip()
                    + "\n"
                )


def migrate(
    config: SourceDataConfig,
    state: MigrationState,
    base_path: Path,
    env: Environment,
    migration_template: Optional[str] = None,
    merge_query_template: Optional[str] = None,
    add_column_migration_template: Optional[str] = None,
):
    table_name = config.target.table_name
    output_dir = base_path / table_name
    output_dir.mkdir(exist_ok=True)

    generate_merge_query(state, env, output_dir, config, merge_query_template)
    generate_migration(
        state,
        env,
        output_dir,
        config,
        migration_template,
        add_column_migration_template,
    )

    state.update_state(table_name, config)


def generate_migrations(
    migration_path: Path,
    configs: List[Dict[str, Any]],
    output_folder: str,
    migration_template: Optional[str] = None,
    merge_query_template: Optional[str] = None,
    add_column_migration_template: Optional[str] = None,
):
    env = get_jinja_env(migration_path / "templates")
    migrations_root_folder = migration_path / "migrations"
    output = migrations_root_folder / output_folder
    state = MigrationState(migrations_root_folder, output / "state.yaml")
    for config in configs:
        migrate(
            config,
            state,
            output,
            env,
            migration_template,
            merge_query_template,
            add_column_migration_template,
        )
    state.save()
