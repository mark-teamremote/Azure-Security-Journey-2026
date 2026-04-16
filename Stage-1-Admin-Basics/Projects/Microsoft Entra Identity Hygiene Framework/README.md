# Microsoft Entra Identity Hygiene Framework

## Day 1 Notes

### Objective
Prepare a small lab tenant state that can be reviewed and improved through identity governance and hardening actions.

### Lab State Created
The tenant was prepared with a small set of test identities to simulate common identity hygiene issues.

Created member users:
- Lab_Stale_User_01
- Lab_Stale_User_02
- Lab_GlobalAdmin_01
- Lab_GlobalAdmin_02
- Lab_NoMFA_01

Created guest users:
- GuestUser1
- GuestUser2

### Baseline Findings
The initial identity review identified the following conditions:

- 2 guest users are present in the tenant
- 2 users have standing Global Administrator role assignments
- 1 user has no usable authentication methods configured
- multiple lab users were created to represent stale or reviewable identities

### Security Observations
- Lab_GlobalAdmin_01 and Lab_GlobalAdmin_02 were assigned Global Administrator as active permanent assignments to simulate standing privilege
- Lab_NoMFA_01 was left without usable authentication methods to represent MFA readiness risk
- Guest users were added to support later governance review scenarios

### Outcome
The lab environment is prepared for identity review and hardening.

## Day 2 Notes

### Objective
Introduce a basic governance control and review the current privileged access and MFA baseline without making broader tenant-wide security changes.

### Actions Taken
- Created a guest access review for the Guest_Access_Review_Lab group
- Configured the review as a one-time review with auto-apply results enabled
- Configured non-response to remove access
- Configured denied guest users to be removed from the reviewed resource
- Confirmed that two guest users are currently in scope for governance review

### Additional Review Findings
- Standing Global Administrator assignments remain present for Lab_GlobalAdmin_01 and Lab_GlobalAdmin_02
- Lab_NoMFA_01 remains without usable authentication methods and represents a baseline MFA readiness gap

### Conditional Access Decision Point
A report-only Conditional Access policy was prepared for the Lab users group. However, the tenant currently has Security Defaults enabled, which must be disabled before Conditional Access policies can be enabled.

For this lighter AZ-104-aligned version of the project, Security Defaults were left enabled and Conditional Access implementation was intentionally deferred.

### Summary
Improved Microsoft Entra identity governance by implementing a guest access review workflow, resulting in a more controlled approach to external access while documenting future Conditional Access hardening steps.

### Outcome
The tenant now includes a working guest governance control, while more advanced policy-based identity hardening has been identified as a future extension better aligned with AZ-500.


