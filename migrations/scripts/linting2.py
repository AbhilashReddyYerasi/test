import sys
import os
from schemachange.cli import JinjaTemplateProcessor, get_schemachange_config
import sqlfluff

def lint_changed_files(file_paths):
    config = get_schemachange_config(
        config_file_path="schemachange-config.yml",
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
        # Append root folder to each file path
        full_path = os.path.join('/home/runner/work/test/test/', file_path)
        print(f"Linting file: {full_path}")
        content = jinja_processor.render(jinja_processor.relpath(full_path), config['vars'], False) + ";\n"
        res = sqlfluff.lint(
            content,
            dialect="snowflake",
            config_path=".sqlfluff"
        )
        if res:
            print(f"================= Errors in {full_path}")
            for r in res:
                print(f"Line {r['line_no']}: {r['description']}")
            raise RuntimeError(f"Linting failed for file: {full_path}")

if __name__ == "__main__":
    try:
        # Print arguments for debugging
        print(f"Arguments: {sys.argv[1:]}")
        # Split the file paths string by spaces and process each file
        lint_changed_files(sys.argv[1].split())
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)
