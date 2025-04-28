@echo off
REM ======================================================
REM   QuantPie Sync Script (versao com seu env atual)
REM   (c) 2024 FullValue.AI - All rights reserved
REM ======================================================

REM Load configuration
setlocal EnableDelayedExpansion
for /f "tokens=* delims=" %%x in (sync_config.env) do (
    set "%%x"
)

REM Check if paths are set
if "%MT5_BASE%"=="" (
    echo ERROR: MT5_BASE is not set in sync_config.env
    exit /b 1
)

echo Syncing QuantPie to MetaTrader 5 Terminal...
echo Base Path: %MT5_BASE%

REM Sync core/
xcopy core\*.mqh "%MT5_BASE%\Include\QuantPie\core\" /s /y /i
xcopy core\components\*.mqh "%MT5_BASE%\Include\QuantPie\core\components\" /s /y /i
xcopy core\managers\*.mqh "%MT5_BASE%\Include\QuantPie\core\managers\" /s /y /i

REM Sync strategies/
xcopy strategies\*.mqh "%MT5_BASE%\Include\QuantPie\strategies\" /s /y /i

REM Sync templates/
xcopy templates\*.mqh "%MT5_BASE%\Include\QuantPie\templates\" /s /y /i

REM Sync experts (production and examples)
xcopy experts\production\*.mq5 "%MT5_BASE%\Experts\QuantPie\production\" /s /y /i
xcopy experts\examples\*.mq5 "%MT5_BASE%\Experts\QuantPie\examples\" /s /y /i

echo Sync completed successfully!

pause
