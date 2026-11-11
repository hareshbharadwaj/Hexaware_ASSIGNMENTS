# Set 3 — Hospital Appointment Booking Application
**Day 3 | 1 November 2026**

## Product vision
Help patients find doctors, book available slots, reschedule or cancel appointments and receive reminders; allow staff to maintain doctor schedules.

## Stakeholders
Patients, doctors, reception staff, hospital administrators and Product Owner.

## Epics and user stories
**Booking:** search doctors by department; view available slots; book a slot.
**Rescheduling & Cancellation:** reschedule an appointment; cancel an appointment; reception staff view booking changes.
**Reminders:** receive confirmation; receive pre-visit reminder; receive change notification.
**Doctor Schedule Management:** administrator adds availability; doctor views daily appointments; administrator blocks unavailable slots.

## INVEST and story splitting
Stories should be Independent, Negotiable, Valuable, Estimable, Small and Testable. Split appointment management into search, slot viewing, booking, rescheduling, cancellation and reminders.

## Acceptance criteria
- Given a signed-in patient and an available slot, when booking is confirmed, then the appointment is saved and a reference is displayed.
- Given the slot has already been booked, when another booking is attempted, then it is rejected and another slot is requested.
- Given required patient details are missing, validation appears and no appointment is created.
- Given an appointment is eligible for cancellation, when confirmed, then its status becomes Cancelled and the slot is released according to hospital policy.

## Prioritisation and estimation
Must: doctor search, slot availability and booking. Should: rescheduling, cancellation and reminders. Could: advanced calendar integration. Example Fibonacci points for 12 stories: 3,5,5,5,3,3,2,3,3,5,3,2 = 42 points.

## JIRA and Sprint Goal
Create a Scrum project, add four epics, stories, acceptance criteria and estimates. Workflow: To Do → In Progress → In Review → Done. Sprint Goal: let a patient search a doctor, view an open slot and book it with confirmation. DoR: value, criteria, dependencies and test notes clear. DoD: reviewed, tested, integrated, criteria passed and demonstrable.
