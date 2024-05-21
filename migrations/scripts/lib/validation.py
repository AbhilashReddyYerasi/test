from pathlib import Path
from typing import List, Set, Tuple


def check_duplicates(versions: List[int]) -> Tuple[bool, Set[int]]:
    duplicates = None
    has_duplicates = len(versions) != len(set(versions))

    if has_duplicates:
        duplicates = {v for v in versions if versions.count(v) > 1}

    return has_duplicates, duplicates


def check_non_consecutive(versions: List[int]) -> Tuple[bool, Set[int]]:
    max_version = max(versions)
    consecutive_versions = set(range(1, (max_version + 1)))

    is_non_consecutive = consecutive_versions != set(versions)
    missing_versions = None

    if is_non_consecutive:
        missing_versions = consecutive_versions - set(versions)

    return is_non_consecutive, missing_versions


def find_migration_versions(migration_path: Path) -> List[int]:
    return [
        int(f.name.split("__")[0].replace("V", ""))
        for f in migration_path.glob("**/V*.sql*")
    ]


def validate_migration_versions(migration_path: Path):
    versions = find_migration_versions(migration_path)
    has_duplicates, duplicates = check_duplicates(versions)
    is_non_consecutive, missing_versions = check_non_consecutive(versions)

    if has_duplicates:
        print("❌ Duplicated migration versions:", duplicates)
    else:
        print("✅ No duplicated versions")

    if is_non_consecutive:
        print("❌ Migration versions are not consecutive:", missing_versions)
    else:
        print("✅ Migrations are consecutive")

    if has_duplicates or is_non_consecutive:
        exit(1)
