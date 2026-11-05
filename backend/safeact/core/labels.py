# backend/safeact/core/labels.py
from typing import Any, Set
from pydantic import BaseModel, Field


class Labeled(BaseModel):
    """
    Wraps any data value flowing through SafeAct with security metadata.
    Enforces taint tracking and provenance lineage.
    """
    value: Any
    vtype: str  # Expected: 'str', 'int', 'bool', 'enum', 'list', 'object'
    tainted: bool = False
    constrained: bool = False
    sources: Set[str] = Field(default_factory=set)

    class Config:
        frozen = False  # Allows mutation if needed, though immutable is often cleaner
        arbitrary_types_allowed = True

    def combine(self, other: "Labeled", new_value: Any, result_vtype: str = "str") -> "Labeled":
        """
        Implements contagious taint propagation.
        If a clean (trusted) value is combined with a tainted value, 
        the resulting value becomes strictly tainted, and its sources 
        are merged into a cumulative lineage set.
        """
        new_tainted = self.tainted or other.tainted
        new_sources = self.sources.union(other.sources)
        
        # Note: Once values are combined/manipulated, they lose their 
        # 'constrained' safety status unless explicitly re-validated by a Reader.
        return Labeled(
            value=new_value,
            vtype=result_vtype,
            tainted=new_tainted,
            constrained=False,
            sources=new_sources
        )