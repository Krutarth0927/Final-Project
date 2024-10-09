import 'package:flutter/material.dart';
import 'package:stayez/color.dart';

class HostelRulesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: accentColor,
          title: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 35.0),
                child: Text('Hostel Rules',style: TextStyle(fontWeight: FontWeight.bold),),
              )),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                buildRuleCard('Attendance and Curfew', 'Strict curfews for entry and exit from the hostel.'),
                buildRuleCard('Guest Policy', 'Rules about visitors, including visiting hours and areas they are allowed to access.'),
                buildRuleCard('Room Allocation and Cleanliness', 'Guidelines for keeping rooms and common areas clean.'),
                buildRuleCard('Noise Control', 'Quiet hours to prevent disturbances to other residents.'),
                buildRuleCard('Prohibited Items', 'Restrictions on the use of alcohol, drugs, and dangerous items.'),
                buildRuleCard('Security Measures', 'Rules regarding hostel ID cards, keys, and safety protocols.'),
                buildRuleCard('Food and Dining', 'Regulations around meal times and cooking within the hostel.'),
                buildRuleCard('Disciplinary Action', 'Consequences for breaking any hostel rules.'),
                buildRuleCard('Room Change Policies', 'Guidelines for requesting room changes.'),
                buildRuleCard('Use of Common Facilities', 'Rules for using shared facilities such as the gym, library, and TV room.'),
                buildRuleCard('Health and Hygiene', 'Ensuring residents maintain hygiene to avoid health risks.'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRuleCard(String title, String description) {
    return Card(
      color: accentColor,
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(description),
          ),
        ],
      ),
    );
  }
}
