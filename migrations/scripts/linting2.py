import sys
from pathlib import Path
from schemachange.cli import JinjaTemplateProcessor, get_schemachange_config
import sqlfluff

def lint_changed_files(file_paths):
    # Load the schemachange configuration
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

    # Initialize the JinjaTemplateProcessor with project root and modules folder from the config
    jinja_processor = JinjaTemplateProcessor(
        project_root=config['root_folder'],
        modules_folder=config['modules_folder'],
    )

    # Determine the base path using the current file's location
    base_path = Path(__file__).resolve().parent

    # Print the list of file paths for debugging
    print(f"File paths to lint: {file_paths}")

    # Iterate over the list of changed files
    for file_path in file_paths:
        try:
            # Construct the full path of the file
            full_path = base_path / file_path
            print(f"Linting file: {full_path}")

            # Render the Jinja template
            content = jinja_processor.render(jinja_processor.relpath(str(full_path)), config['vars'], False) + ";\n"

            # Lint the rendered content using sqlfluff
            res = sqlfluff.lint(
                content,
                dialect="snowflake",
                config_path=".sqlfluff"
            )

            # If there are linting errors, print them and raise an error to stop the workflow
            if res:
                print(f"================= Errors in {full_path}")
                for r in res:
                    print(f"Line {r['line_no']}: {r['description']}")
                raise RuntimeError(f"Linting failed for file: {full_path}")

        except Exception as e:
            print(f"Error processing file {file_path}: {e}")
            raise

if __name__ == "__main__":
    try:
        # Print raw arguments for debugging
        print(f"Raw Arguments: {sys.argv}")

        # Split the file paths string by spaces and process each file
        file_paths = sys.argv[1:]
        print(f"Processed file paths: {file_paths}")

        # Call the linting function with the processed file paths
        lint_changed_files(file_paths)

        print("All linting finished successfully")
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)
