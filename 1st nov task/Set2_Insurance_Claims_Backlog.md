# Set 2 — Insurance Claims Portal
**Day 3 | 1 November 2026**

## Product vision
Give policyholders a guided digital way to register claims, upload evidence, track progress and receive settlement decisions.

## Waterfall vs Agile
Waterfall delivers in sequential phases with controlled changes. Agile delivers increments, gathers feedback and reprioritises. Agile enables earlier validation of claim forms, evidence requirements and status visibility.

## Epics and user stories
**Claim Registration:** sign in securely; select a policy; submit incident details; receive a claim reference.
**Document Upload:** upload evidence; view upload status; claims officer reviews submitted documents.
**Claim Tracking:** view claim status; officer updates status; policyholder sees requests for more information.
**Settlement Notifications:** receive decision notification; view settlement details; officer records settlement.

## INVEST and vertical splitting
Stories should be Independent, Negotiable, Valuable, Estimable, Small and Testable. Split “complete claim management” into vertical slices: register claim, attach evidence, view status and receive decision.

## Acceptance criteria — claim registration
- Given an authenticated policyholder selects an active policy and enters valid mandatory details, when submitted, then a claim with a unique reference is created.
- Given mandatory details are missing, when submitted, then field validation appears and no claim is created.
- Given the selected policy is inactive or belongs to another user, submission is blocked.

## Prioritisation and estimation
Must: registration, reference generation and document upload. Should: tracking and information requests. Could: configurable notification preferences. Example Fibonacci estimates across 13 stories: 3,3,8,2,5,3,5,5,3,3,3,5,5 = 56 points.

## JIRA and Scrum
Use To Do → In Progress → In Review → Done. Product Owner orders the backlog; Scrum Master supports the process; Developers deliver the Increment. Events: Sprint Planning, Daily Scrum, Sprint Review and Sprint Retrospective. DoD: acceptance criteria met, access controls tested, code reviewed, automated tests pass, integrated and demonstrable.
