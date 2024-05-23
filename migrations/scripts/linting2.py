import sys
from schemachange.cli import JinjaTemplateProcessor, get_schemachange_config
import sqlfluff

def lint_changed_files(file_paths):
    config = get_schemachange_config(
        config_file_path="migrations/raw/schemachange-config.yml",
        vars=None,
        verbose=False,
        root_folder=None,
        modules_folder=None,
        snowflake_account=None,
        snowflake_user=None,
        snowflake_role=None,
        snowflake_warehouse=None,
        snowflake_database=None,
        change_history_table=None,
        snowflake_schema=None,
        create_change_history_table=None,
        autocommit=None,
        query_tag=None,
        oauth_config=None,
        dry_run=True
    )

    jinja_processor = JinjaTemplateProcessor(
        project_root=config['root_folder'],
        modules_folder=config['modules_folder'],
    )

    for file_path in file_paths:
        print(file_path)
        content = jinja_processor.render(jinja_processor.relpath(file_path), config['vars'], False) + ";\n"
        res = sqlfluff.lint(
            content,
            dialect="snowflake",
            config_path="migrations/raw/.sqlfluff"
        )
        if res:
            print("=================", file_path)
            for r in res:
                print(r["line_no"], r["description"], r)
            raise RuntimeError(f"Linting failed for file: {file_path}")

if __name__ == "__main__":
    try:
        lint_changed_files(sys.argv[1:])
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)
