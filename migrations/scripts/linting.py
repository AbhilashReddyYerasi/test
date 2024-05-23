from pathlib import Path
from schemachange.cli import JinjaTemplateProcessor, get_schemachange_config
import sqlfluff

config = get_schemachange_config(
    config_file_path="E:\\TestFileFlow and Github Actions\\test\\migrations\\raw\\schemachange-config.yml",
    vars=None,
    verbose=False,
    root_folder=None,
    modules_folder=None,
    snowflake_account = None,
    snowflake_user = None,
    snowflake_role = None,
    snowflake_warehouse = None,
    snowflake_database = None,
    change_history_table = None,
    snowflake_schema = None,
    create_change_history_table = None,
    autocommit = None,
    query_tag = None,
    oauth_config = None,
    dry_run=True
)

jinja_processor = JinjaTemplateProcessor(
    project_root = config['root_folder'],
    modules_folder = config['modules_folder'],
)

for f in Path('E:\\TestFileFlow and Github Actions\\test\\migrations\\raw\\migrations\\cfx').glob("**/V*.sql*"):
    print(f)
    content = jinja_processor.render(jinja_processor.relpath(f), config['vars'], False) + ";\n"
    # print(content)
    res = (sqlfluff.lint(
        content,
        dialect="snowflake",
        # exclude_rules=["layout.indent"],["PRS"]
        config_path="E:\\TestFileFlow and Github Actions\\test\\migrations\\raw\\.sqlfluff"))
    if res:
        print("=================", f)
        for r in res:
            print(r)
            print(r["line_no"], r["description"], r)
        break