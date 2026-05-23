from typing import List

from .entry import Entry, LabsEntry, PracticeEntry, ThesisEntry


def labs(count: int) -> List[str]:
    return [str(i + 1) for i in range(count)]


DISCIPLINES: List[Entry] = [
    ThesisEntry("BackelorsThesis", "backelors"),
    PracticeEntry("BackelorPreGraduationPractice", "pre-graduation"),
    LabsEntry(1, "EntranceToC", "c", labs(7)),
    LabsEntry(8, "HumanMachineInteraction", "hmi", labs(4)),
    LabsEntry(8, "MetrologyStandardizationCertification", "msc", labs(5)),
]
