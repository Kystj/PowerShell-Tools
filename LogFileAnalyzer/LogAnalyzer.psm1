# LogFileAnalyzer.psm1

function Get-LogFileContent {
    <#
    .SYNOPSIS
    Retrieves and filters log file content based on given parameters.

    .DESCRIPTION
    This function reads a log file and filters its contents based on the provided date range,
    severity level, and keyword. It supports searching for logs by start and end dates, severity level,
    and a keyword within the log message.

    .PARAMETER FilePath
    The full path to the log file.

    .PARAMETER StartDate
    The start date for filtering logs. If not provided, no date filtering is applied.

    .PARAMETER EndDate
    The end date for filtering logs. If not provided, no date filtering is applied.

    .PARAMETER Severity
    The severity level to filter logs. Possible values: ERROR, WARNING, INFO.

    .PARAMETER Keyword
    A keyword to search for within the log messages.

    .EXAMPLE
    Get-LogFileContent -FilePath "C:\logs\server.log" -StartDate "2025-03-01" -EndDate "2025-03-05" -Severity "ERROR"

    This command retrieves all ERROR logs from the file "server.log" between March 1st, 2025, and March 5th, 2025.

    .EXAMPLE
    Get-LogFileContent -FilePath "C:\logs\app.log" -Keyword "database"

    This command retrieves all logs containing the keyword "database" from the file "app.log".

    .NOTES
    FilePath, StartDate, EndDate, Severity, and Keyword are all optional parameters.
    If no filters are applied, all logs from the file will be returned.
    #>

    param (
        [string]$FilePath,
        [datetime]$StartDate,
        [datetime]$EndDate,
        [string]$Severity,
        [string]$Keyword
    )

    # Confirm the file path
    if (-not (Test-Path $FilePath)) {
        Write-Output "Error: File path does not exist or is not accessible."
        return $null
    }

    # Read content from the log file
    Write-Output "Reading and parsing the log file..."
    $Logs = Get-Content $FilePath -Encoding UTF8

    # Ensure the log file contains at least one valid log entry
    if (-not ($Logs -match '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[\w+\] .+')) {
        Write-Output "Error: Log file does not contain valid log entries."
        return $null
    }

    # Store the filtered logs in an array
    $FilteredLogs = @()

    foreach ($Line in $Logs) {
        # Match the log entry format
        if ($Line -match '^(?<Date>\d{4}-\d{2}-\d{2}) (?<Time>\d{2}:\d{2}:\d{2}) \[(?<Severity>\w+)\] (?<Message>.+)$') {
            $LogDate = [datetime]::ParseExact($matches.Date + " " + $matches.Time, "yyyy-MM-dd HH:mm:ss", $null)
            $LogSeverity = $matches.Severity
            $LogMessage = $matches.Message

            # Apply filters
            if ($StartDate -and ($LogDate -lt $StartDate)) { continue }
            if ($EndDate -and ($LogDate -gt $EndDate)) { continue }
            if ($Severity -and ($LogSeverity -notlike $Severity)) { continue }

            # Keyword filter with case-insensitive matching with * for partial match
            if ($Keyword -and ($LogMessage -notlike "*$Keyword*")) { continue }

            # Add a log entry to filtered logs
            $FilteredLogs += [PSCustomObject]@{
                Date     = $matches.Date
                Time     = $matches.Time
                Severity = $matches.Severity
                Message  = $matches.Message
            }
        } else {
            Write-Output "Skipping invalid log line: $Line"
        }
    }

    Write-Output "Filtering complete. Logs matching criteria: $($FilteredLogs.Count)"
    return $FilteredLogs
}

Export-ModuleMember -Function Get-LogFileContent