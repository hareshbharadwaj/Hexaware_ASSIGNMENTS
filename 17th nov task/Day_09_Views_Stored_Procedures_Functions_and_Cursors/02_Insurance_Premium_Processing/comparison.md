# Cursor versus set-based processing

The cursor fetches each expired policy, updates its status, inserts an audit/log row and increments the INOUT counter. The set-based version inserts log rows for the qualifying set and updates all matching policies in one transaction. Set-based SQL generally reduces procedural overhead. Execute the alternatives separately against reset data. The INOUT example returns the number processed by the cursor. Measure elapsed time on the same MySQL instance and dataset.
