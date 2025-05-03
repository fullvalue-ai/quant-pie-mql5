@echo off
REM ======================================================
REM   QuantPie Sync Script (versão atualizada)
REM   (c) 2024 FullValue.AI - All rights reserved
REM ======================================================

REM Load configuration
setlocal EnableDelayedExpansion
for /f "tokens=* delims=" %%x in (sync_config.env) do (
    set "%%x"
)

REM Check if MT5_BASE is set
if "%MT5_BASE%"=="" (
    echo ERROR: MT5_BASE is not set in sync_config.env
    exit /b 1
)

echo.
echo Syncing QuantPie to MetaTrader 5 Terminal...
echo Base Path: %MT5_BASE%
echo.

REM Create target folders if they don't exist
mkdir "%MT5_BASE%\Include\QuantPie\core\builders"     2>nul
mkdir "%MT5_BASE%\Include\QuantPie\core\components"   2>nul
mkdir "%MT5_BASE%\Include\QuantPie\core\config"       2>nul
mkdir "%MT5_BASE%\Include\QuantPie\core\helpers"      2>nul
mkdir "%MT5_BASE%\Include\QuantPie\core\systems"      2>nul
mkdir "%MT5_BASE%\Include\QuantPie\core\types"        2>nul

mkdir "%MT5_BASE%\Include\QuantPie\strategies"        2>nul
mkdir "%MT5_BASE%\Include\QuantPie\templates"         2>nul

mkdir "%MT5_BASE%\Experts\QuantPie\examples"          2>nul
mkdir "%MT5_BASE%\Experts\QuantPie\production"        2>nul
mkdir "%MT5_BASE%\Experts\QuantPie\tests"             2>nul

REM Sync core/builders
xcopy core\builders\*.mqh      "%MT5_BASE%\Include\QuantPie\core\builders\"    /s /y /i

REM Sync core/components
xcopy core\components\*.mqh    "%MT5_BASE%\Include\QuantPie\core\components\"  /s /y /i

REM Sync core/config
xcopy core\config\*.mqh        "%MT5_BASE%\Include\QuantPie\core\config\"      /s /y /i

REM Sync core/helpers
xcopy core\helpers\*.mqh       "%MT5_BASE%\Include\QuantPie\core\helpers\"     /s /y /i

REM Sync core/systems
xcopy core\systems\*.mqh       "%MT5_BASE%\Include\QuantPie\core\systems\"     /s /y /i

REM Sync core/types
xcopy core\types\*.mqh         "%MT5_BASE%\Include\QuantPie\core\types\"       /s /y /i

REM Sync strategies
xcopy strategies\*.mqh         "%MT5_BASE%\Include\QuantPie\strategies\"      /s /y /i

REM Sync templates
xcopy templates\*.mqh          "%MT5_BASE%\Include\QuantPie\templates\"       /s /y /i

REM Sync experts (examples and production)
xcopy experts\examples\*.mq5   "%MT5_BASE%\Experts\QuantPie\examples\"         /s /y /i
xcopy experts\production\*.mq5 "%MT5_BASE%\Experts\QuantPie\production\"       /s /y /i

REM Sync tests
xcopy tests\*.mq5              "%MT5_BASE%\Experts\QuantPie\tests\"            /s /y /i

echo.
echo Sync completed successfully!
pause
