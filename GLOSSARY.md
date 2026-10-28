# Clinic Appointment System

Patients book appointments with clinic staff at a concrete place and time;
admins define where and when the institution works.

## Institution

**Clinic**:
An institution that provides care under one name and owns one or more branches.
_Avoid_: Hospital, institution, organization

**Branch**:
A physical location of a clinic where appointments take place; it has its own working hours.
_Avoid_: Location, site, office

**Department**:
A medical unit inside a branch, such as cardiology or radiology, that staff belong to.
_Avoid_: Unit, section, specialty

**Working hours**:
The time ranges in each weekday during which a branch is open.
_Avoid_: Opening hours, schedule, availability

**Closed day**:
A weekday on which a branch has no working hours.
_Avoid_: Holiday, day off
