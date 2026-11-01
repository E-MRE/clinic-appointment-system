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

## Availability

**Availability window**:
A time range during which a doctor or technician accepts appointments; it must lie inside one range of the branch's working hours.
_Avoid_: Shift, schedule, working hours

**Weekly window**:
An availability window that recurs every week on one weekday.
_Avoid_: Recurring shift, template

**One-off window**:
An availability window on one calendar date, added on top of that date's weekly windows; it never replaces them.
_Avoid_: Exception, override, extra shift

**Slot**:
A bookable start time produced by splitting an availability window back to back by a service duration; a remainder shorter than the duration is dropped.
_Avoid_: Appointment, time slot booking
