---
external help file: MSPHelper-help.xml
Module Name: MSPHelper
online version:
schema: 2.0.0
---

# Test-IsDomainController

## SYNOPSIS

Tests to see if the object is a Domain Controller

## SYNTAX

```
Test-IsDomainController [[-ComputerName] <String>] [<CommonParameters>]
```

## DESCRIPTION

This function will test if the target computer (or local computer) is a domain controller and return $true of $false in a boolean format.

## EXAMPLES

### EXAMPLE 1

```
Test-IsDomainController
```

Returns true or false if the local computer is a domain controller

### EXAMPLE 2

```
Test-IsDomainController -ComputerName DC01
```

Returns true or false if the DC01 computer is a domain controller

### EXAMPLE 3

```
Get-ADComputer -Filter * | Test-IsDomainController
```

Returns true or false if the computer is a domain controller

## PARAMETERS

### -ComputerName

(Optional) The computer name to test.
If not specified, the local computer will be tested.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $env:computername
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [String] (ComputerName). Can be used to specify a remote computer. Accepts pipeline input.

## OUTPUTS

### [Boolean] (True or False). Returns true if the computer is a domain controller, false if not.

## NOTES

## RELATED LINKS
