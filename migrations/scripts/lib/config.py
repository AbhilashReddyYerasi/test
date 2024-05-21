from dataclasses import dataclass
from pathlib import Path
from typing import Any, Callable, Dict, List, Optional
import os

from dataclass_wizard import JSONWizard, YAMLWizard

@dataclass
class Column(JSONWizard):
    name: str
    type: str
    transformation: Optional[str] = None


@dataclass
class CmsSource:
    database: str
    schedule: str
    table_name: str
    query: Optional[str] = None


@dataclass
class ZohoCrmSource:
    query: Dict
    
    
@dataclass
class CfxSource:
    table_name: str
    file_name: Optional[str] = None


@dataclass
class CmsAuditSource:
    schedule: str
    table_name: str
    file_name: str
    query: Optional[str] = None

@dataclass
class PricingSource:
    table_name: str

@dataclass
class FinanceSource:
    table_name: str

@dataclass
class Call3cxSource:
    table_name: str

@dataclass
class OracleSource:
    table_name: str
    
@dataclass
class StreamingSource:
    table_name: str

@dataclass
class Source:
    cms: Optional[CmsSource] = None
    zoho_crm: Optional[ZohoCrmSource] = None
    cms_audit: Optional[CmsAuditSource] = None
    cfx: Optional[CfxSource] = None
    pricing: Optional[PricingSource] = None
    finance: Optional[FinanceSource] = None
    call_3cx: Optional[Call3cxSource] = None
    oracle: Optional[OracleSource] = None
    streaming: Optional[StreamingSource] = None

@dataclass
class Target:
    schema: str
    table_name: str
    unique_id: str
    generate_migrations: Optional[bool] = True
    generate_merge_query: Optional[bool] = True


@dataclass
class SourceDataConfig(YAMLWizard, JSONWizard):
    columns: List[Column]
    source: Source
    target: Target

    def to_jinja_context(self) -> Dict[str, Any]:
        if self.source.cms:
            return {
                "table_name": self.target.table_name,
                "stage": "cms_stage",
                "file_name": self.source.cms.table_name,
                "columns": [c.to_dict() for c in self.columns],
                "unique_id": self.target.unique_id,
            }
        elif self.source.zoho_crm:
            return {
                "table_name": self.target.table_name,
                "stage": "zoho_crm_stage",
                "file_name": self.target.table_name,
                "columns": [c.to_dict() for c in self.columns],
                "unique_id": self.target.unique_id,
            }
        elif self.source.cms_audit:
            return {
                "table_name": self.target.table_name,
                "stage": "cms_audit_stage",
                "file_name": self.source.cms_audit.file_name,
                "columns": [c.to_dict() for c in self.columns],
                "unique_id": self.target.unique_id,
            }
        elif self.source.cfx:
            return {
                "table_name": self.target.table_name,
                "stage": "cfx_stage",
                "file_name": self.source.cfx.file_name if self.source.cfx.file_name is not None else self.target.table_name,
                "columns": [c.to_dict() for c in self.columns],
                "unique_id": self.target.unique_id,
            }
        elif self.source.pricing:
            return {
                "table_name": self.target.table_name,
                "stage": "pricing_stage",
                "file_name": self.source.pricing.table_name,
                "columns": [c.to_dict() for c in self.columns],
                "unique_id": self.target.unique_id,
            }
        elif self.source.finance:
            return {
                "table_name": self.target.table_name,
                "stage": "finance_stage",
                "file_name": self.source.finance.table_name,
                "columns": [c.to_dict() for c in self.columns],
                "unique_id": self.target.unique_id,
            }
        elif self.source.call_3cx:
            return {
                "table_name": self.target.table_name,
                "stage": "call_3cx_stage",
                "file_name": self.source.call_3cx.table_name,
                "columns": [c.to_dict() for c in self.columns],
                "unique_id": self.target.unique_id,
            }
        elif self.source.oracle:
            return {
                "table_name": self.target.table_name,
                "stage": "oracle_stage",
                "file_name": self.source.oracle.table_name,
                "columns": [c.to_dict() for c in self.columns],
                "unique_id": self.target.unique_id,
            }
        elif self.source.streaming:
            return {
                "table_name": self.target.table_name,
                "stage": "streaming_stage",
                "file_name": f"eh-dhdp-{env}_shipments",
                "columns": [c.to_dict() for c in self.columns],
                "unique_id": self.target.unique_id,
            }
        raise RuntimeError(f"Unknown data source: {self.source}")


def load_configurations(
    config_path: Path, filter: Optional[Callable[[SourceDataConfig], bool]] = None
) -> List[SourceDataConfig]:
    configs = []
    for p in config_path.glob("**/*.yaml"):
        config = SourceDataConfig.from_yaml_file(p)
        if not filter or filter(config):
            configs.append(config)
    return configs
