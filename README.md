otrs-improvedfields
===================

Adds new fields to OTRS: 

### Regular Expression Field

Adds a field that can be validated using regular expression.  

Examples:

*Phone Validation*

    ^\([0-9]{3}\) [1-9]{3}-[0-9]{4}$

__Matches any phone number in the format of (555) 555-5555 (american style numbers)__

*Numbers Only*

    ^[0-9]*$
    
__forces input to contain only numbers__

*Alpha Only*

    ^[a-zA-Z]*$

__forces input to contain only characters__

Validated using http://www.regexpal.com/

### Improved Date/Time Field

Date/Time field no longer requires user to check the box to include the date/time.  Checkbox for inclusion is included on reporting screens.  (saves about 1 click)

### Autocomplete Field

A lookup field that provides a jQuery UI Auto-Complete to either the Agent or Customer table. 

### Tabular Data Field

Adds a data-table for collecting tabular data. 

The column ordering is validated with the following regex: `^[0-9]{n}(:[and]?[r]?)?$`

#### Validation types are: 
* Not specified = No validation performed
* ~~a = alpha only~~
* ~~n = numeric only~~
* d = datetime fields
* r = required column

__~~strikethrough~~ == not yet implemented__

