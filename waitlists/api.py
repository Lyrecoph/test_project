from typing import List

from ninja import Router
from django.shortcuts import get_object_or_404

from .models import WaitlistEntry
from .schemas import WaitlistEntryListSchema, WaitlistEntryDetailSchema
router = Router()

# # Get and List Models via Django Ninja Router
# Récupère la liste des éléments
@router.get('', response=List[WaitlistEntryListSchema])
def list_waitlist_entries(request):
    qs = WaitlistEntry.objects.all()
    return qs

# Récupère le détail d'un élément
@router.get('{entry_id}', response=WaitlistEntryDetailSchema)
def get_waitlist_entry(request, entry_id: int):
    obj = get_object_or_404(WaitlistEntry, id=entry_id)
    return obj