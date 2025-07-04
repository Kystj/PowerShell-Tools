# PowerShell-ToolsLog File Analyzer (PowerShell Module)

# Overview
LogFileAnalyzer.psm1 is a PowerShell module designed to help you efficiently read and filter log files based on multiple criteria, such as date range, severity level, and message keywords. It is ideal for analyzing large text-based log files from applications or servers.

# Features

    Reads plain-text log files line-by-line.

    Filters logs by:

        Date range (StartDate and EndDate)

        Severity level (INFO, WARNING, ERROR)

        Keyword matching within the message body

    Returns structured output with date, time, severity, and message

    Skips malformed log entries with an informative message

# Log Format

    This module expects logs to follow a standardized format:
    
    YYYY-MM-DD HH:MM:SS [SEVERITY] Message content...
    
    Example:
    
    2025-03-02 14:23:11 [ERROR] Failed to connect to database.


Import-Module .\LogFileAnalyzer.psm1

# Usage Instructions

Run the Get-LogFileContent function with the desired parameters:

    Get-LogFileContent -FilePath "C:\Logs\app.log"

Optional Parameters

    -StartDate "YYYY-MM-DD" — only show logs on or after this date

    -EndDate "YYYY-MM-DD" — only show logs on or before this date

    -Severity "ERROR" — filter by severity level (INFO, WARNING, ERROR)

    -Keyword "database" — match logs containing this keyword (case-insensitive)

# Examples

Example 1: Filter by date and severity

    Get-LogFileContent -FilePath "C:\Logs\server.log" -StartDate "2025-03-01" -EndDate "2025-03-05" -Severity "ERROR"

    Retrieves all ERROR level logs between March 1st and March 5th, 2025.

Example 2: Search for a keyword

    Get-LogFileContent -FilePath "C:\Logs\app.log" -Keyword "timeout"

    Returns all log entries that mention "timeout".



