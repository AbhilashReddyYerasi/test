from pathlib import Path

import typer

from .lib.config import load_configurations
from .lib.migration_autogeneration import generate_migrations
from .lib.migration_state import MigrationState
from .lib.validation import validate_migration_versions

MIGRATION_PATH = Path(__file__).parent.parent.resolve() / "raw"

app = typer.Typer()


@app.command()
def next_migration_version(migrations_path: Path):
    state = MigrationState(migrations_path)
    print("Next migration version:", f"V{state.get_migration_version()}")


@app.command()
def validate_migrations(migrations_path: Path):
    validate_migration_versions(migrations_path)


@app.command()
def generate_migrations_from_yaml(config_path: Path):
    configs = load_configurations(
        config_path, lambda config: config.target.schema == "cms"
    )
    generate_migrations(
        MIGRATION_PATH,
        configs,
        "cms",
        "cms_migration.sql.jinja",
        "cms_merge_query.sql.jinja",
        "cms_migration_add_columns.sql.jinja",
    )

    configs = load_configurations(
        config_path, lambda config: config.target.schema == "zoho_crm"
    )
    generate_migrations(
        MIGRATION_PATH,
        configs,
        "zoho_crm",
        "zoho_crm_migration.sql.jinja",
        "zoho_crm_merge_query.sql.jinja",
    )
    
    configs = load_configurations(
        config_path, lambda config: config.target.schema == "cfx"
    )
    generate_migrations(
        MIGRATION_PATH,
        configs,
        "cfx",
        "cfx_migration.sql.jinja",
        "cfx_merge_query.sql.jinja",
    )

    configs = load_configurations(
        config_path, lambda config: config.target.schema == "cms_audit"
    )
    generate_migrations(
        MIGRATION_PATH,
        configs,
        "cms_audit",
        "cms_audit_migration.sql.jinja",
        "cms_audit_merge_query.sql.jinja",
    )
    
    configs = load_configurations(
        config_path, lambda config: config.target.schema == "pricing"
    )
    generate_migrations(
        MIGRATION_PATH,
        configs,
        "pricing",
        "pricing_migration.sql.jinja",
        "pricing_merge_query.sql.jinja",
    )
        
    configs = load_configurations(
        config_path, lambda config: config.target.schema == "finance"
    )
    generate_migrations(
        MIGRATION_PATH,
        configs,
        "finance",
        "finance_migration.sql.jinja",
        "finance_merge_query.sql.jinja",
    )

    configs = load_configurations(
        config_path, lambda config: config.target.schema == "call_3cx"
    )
    generate_migrations(
        MIGRATION_PATH,
        configs,
        "call_3cx",
    )
    
    configs = load_configurations(
        config_path, lambda config: config.target.schema == "oracle"
    )
    generate_migrations(
        MIGRATION_PATH,
        configs,
        "oracle",
        "oracle_migration.sql.jinja",
        "oracle_merge_query.sql.jinja",
    )
    
    configs = load_configurations(
        config_path, lambda config: config.target.schema == "streaming"
    )
    generate_migrations(
        MIGRATION_PATH,
        configs,
        "streaming",
    )


if __name__ == "__main__":
    app()
