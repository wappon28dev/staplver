import 'dart:convert';

const uss = [
  {
    'label': 'A',
    'children': [
      {'label': 'Alabama', 'key': 'AL'},
      {'label': 'Alaska', 'key': 'AK'},
      {'label': 'American Samoa', 'key': 'AS'},
      {'label': 'Arizona', 'key': 'AZ'},
      {'label': 'Arkansas', 'key': 'AR'}
    ]
  },
  {
    'label': 'C',
    'children': [
      {'label': 'California', 'key': 'CA'},
      {'label': 'Colorado', 'key': 'CO'},
      {'label': 'Connecticut', 'key': 'CT'},
    ]
  },
  {
    'label': 'D',
    'children': [
      {'label': 'Delaware', 'key': 'DE'},
      {'label': 'District Of Columbia', 'key': 'DC'},
    ]
  },
  {
    'label': 'F',
    'children': [
      {'label': 'Federated States Of Micronesia', 'key': 'FM'},
      {'label': 'Florida', 'key': 'FL'},
    ]
  },
  {
    'label': 'G',
    'children': [
      {'label': 'Georgia', 'key': 'GA'},
      {'label': 'Guam', 'key': 'GU'},
    ]
  },
  {
    'label': 'H',
    'children': [
      {'label': 'Hawaii', 'key': 'HI'},
    ]
  },
  {
    'label': 'I',
    'children': [
      {'label': 'Idaho', 'key': 'ID'},
      {'label': 'Illinois', 'key': 'IL'},
      {'label': 'Indiana', 'key': 'IN'},
      {'label': 'Iowa', 'key': 'IA'},
    ]
  },
  {
    'label': 'K',
    'children': [
      {'label': 'Kansas', 'key': 'KS'},
      {'label': 'Kentucky', 'key': 'KY'},
    ]
  },
  {
    'label': 'L',
    'children': [
      {'label': 'Louisiana', 'key': 'LA'},
    ]
  },
  {
    'label': 'M',
    'children': [
      {'label': 'Maine', 'key': 'ME'},
      {'label': 'Marshall Islands', 'key': 'MH'},
      {'label': 'Maryland', 'key': 'MD'},
      {'label': 'Massachusetts', 'key': 'MA'},
      {'label': 'Michigan', 'key': 'MI'},
      {'label': 'Minnesota', 'key': 'MN'},
      {'label': 'Mississippi', 'key': 'MS'},
      {'label': 'Missouri', 'key': 'MO'},
      {'label': 'Montana', 'key': 'MT'},
    ]
  },
  {
    'label': 'N',
    'children': [
      {'label': 'Nebraska', 'key': 'NE'},
      {'label': 'Nevada', 'key': 'NV'},
      {'label': 'New Hampshire', 'key': 'NH'},
      {'label': 'New Jersey', 'key': 'NJ'},
      {'label': 'New Mexico', 'key': 'NM'},
      {'label': 'New York', 'key': 'NY'},
      {'label': 'North Carolina', 'key': 'NC'},
      {'label': 'North Dakota', 'key': 'ND'},
      {'label': 'Northern Mariana Islands', 'key': 'MP'},
    ]
  },
  {
    'label': 'O',
    'children': [
      {'label': 'Ohio', 'key': 'OH'},
      {'label': 'Oklahoma', 'key': 'OK'},
      {'label': 'Oregon', 'key': 'OR'},
    ]
  },
  {
    'label': 'P',
    'children': [
      {'label': 'Palau', 'key': 'PW'},
      {'label': 'Pennsylvania', 'key': 'PA'},
      {'label': 'Puerto Rico', 'key': 'PR'},
    ]
  },
  {
    'label': 'R',
    'children': [
      {'label': 'Rhode Island', 'key': 'RI'},
    ]
  },
  {
    'label': 'S',
    'children': [
      {'label': 'South Carolina', 'key': 'SC'},
      {'label': 'South Dakota', 'key': 'SD'},
    ]
  },
  {
    'label': 'T',
    'children': [
      {'label': 'Tennessee', 'key': 'TN'},
      {'label': 'Texas', 'key': 'TX'},
    ]
  },
  {
    'label': 'U',
    'children': [
      {'label': 'Utah', 'key': 'UT'},
    ]
  },
  {
    'label': 'V',
    'children': [
      {'label': 'Vermont', 'key': 'VT'},
      {'label': 'Virgin Islands', 'key': 'VI'},
      {'label': 'Virginia', 'key': 'VA'},
    ]
  },
  {
    'label': 'W',
    'children': [
      {'label': 'Washington', 'key': 'WA'},
      {'label': 'West Virginia', 'key': 'WV'},
      {'label': 'Wisconsin', 'key': 'WI'},
      {'label': 'Wyoming', 'key': 'WY'}
    ]
  },
];

String us = jsonEncode(uss);
