# Personnaliser le model Django avec Ninja schema
from datetime import datetime
from ninja import Schema
from pydantic import EmailStr

# Pour la création nous aurons juste besoin du email
class WaitlistEntryCreateSchema(Schema):
    email: EmailStr
    
# Pour afficher la liste des éléments
class WaitlistEntryListSchema(Schema):
    id: int
    email: EmailStr
    
# Pour afficher les détails nous utiliserons email et timestamp   
class WaitlistEntryDetailSchema(Schema):
    id: int
    email: EmailStr
    updated: datetime
    timestamp: datetime