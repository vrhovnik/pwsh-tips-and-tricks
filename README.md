<!-- TOC -->
* [PowerShell tips and tricks from daily usage](#powershell-tips-and-tricks-from-daily-usage)
  * [Pre-requisites](#pre-requisites)
  * [TL;DR](#tldr)
* [Additional links](#additional-links)
* [Contributing](#contributing)
<!-- TOC -->

# PowerShell tips and tricks from daily usage

PowerShell is a cross-platform task automation solution made up of a command-line shell, a scripting language, and a
configuration management framework. PowerShell runs on Windows, Linux, and macOS.
This is a repository for session on **Tips and tricks from working with PowerShell daily**. Focusing on productivity,
usage and hidden tricks to get to the desired state.

If you are not familiar with PowerShell, you can start by reading
the [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/).

In this demo repository we will look through common uses of PowerShell, some obvious, but some not so obvious operations
to help you with day to day tasks.

## Pre-requisites

You will need to have PowerShell installed. Check instructions [here](https://go.azuredemos.net/docs-pwsh-home). 
You can run all of the demos **without** any profiles or modules installed.

When there will be a need to install specific module, you can see instructions how to install specific module (
Install-Module ....).

I've shown demos in 7.3.1 version of PowerShell, but most of the demos will work in previous versions as well.

To be able to run the demos in [modules](./scripts/04-modules.ps1) part, you will need to compile the code
in [src folder](./src/PWSHDemos) before you can use it in PowerShell session. To be able to do that, you will need to have [.NET installed](https://dot.net).

```powershell

Set-Location "src/PWSHDemos/PWSH.K8S"
dotnet build "PWSH.K8S.csproj"

```

## TL;DR

Start exploring by clicking image below to get into the flow script file:

[![button](https://webeudatastorage.blob.core.windows.net/web/right-arrow.png)](./scripts/00-flow.ps1)

# Additional links

```powershell

$powershell-docs = Start-Process "https://go.azuredemos.net/docs-pwsh-home"
$powershell-github = Start-Process "https://github.com/PowerShell/PowerShell.git"
$windows-terminal = Start-Process "https://go.azuredemos.net/docs-terminal-home"
$windows-terminal-github-page = Start-Process "https://github.com/microsoft/terminal.git"
$powershell-module-considerations = Start-Process "https://learn.microsoft.com/en-us/powershell/scripting/dev-cross-plat/performance/module-authoring-considerations?view=powershell-7.3"

```

# Contributing

This project welcomes contributions and suggestions. Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
