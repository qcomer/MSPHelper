---
external help file: MSPHelper-help.xml
Module Name: MSPHelper
online version:
schema: 2.0.0
---

# Test-IsModuleInstalledandUpdated

## SYNOPSIS
Checks to see if a module is installed and up-to-date.

## SYNTAX

```
Test-IsModuleInstalledandUpdated [-ModuleName] <String> [-DoNotUpdate] [[-DoNotInstall] <Object>]
 [<CommonParameters>]
```

## DESCRIPTION
Checks to see if the provided module name(s) are installed and up-to-date.

## EXAMPLES

### EXAMPLE 1
```
Test-ModuleInstalled -ModuleName 'ActiveDirectory'
```

Returns true or false if the ActiveDirectory module is installed and up-to-date.

### EXAMPLE 2
```
Test-ModuleInstalled -ModuleName 'ActiveDirectory' -DoNotUpdate
```

Returns true or false if the ActiveDirectory module is installed regardless of version.

### EXAMPLE 3
```
Test-ModuleInstalled -ModuleName 'ActiveDirectory' -DoNotInstall
```

Returns true or false if the ActiveDirectory module is installed.
Does not install if not installed.

### EXAMPLE 4
```
Test-ModuleInstalled -ModuleName 'ActiveDirectory' -DoNotUpdate -DoNotInstall
```

Returns true or false if the ActiveDirectory module is installed regardless of version.
Does not install if not installed.

## PARAMETERS

### -ModuleName
(Required) The name of the module to test (and update).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -DoNotUpdate
(Optional) If specified, the module will not be updated if it is not the latest version.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DoNotInstall
(Optional) If specified, the module will not be installed if it is not installed.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [String] (ModuleName). Specifies the Module Name. Accepts pipeline input.
### [Switch] (DoNotUpdate). Specifies that the module should not be updated if it is not the latest version.
### [Switch] (DoNotInstall). Specifies that the module should not be installed if it is not installed.
## OUTPUTS

### [Boolean] (True or False). Returns true if the module conditions meet the parameters.
### [String] (Verbose). Returns a verbose message detailing the status of the module.
## NOTES
N/A

## RELATED LINKS
