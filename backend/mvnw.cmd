@echo off
setlocal
set "DIR=%~dp0"
set "WRAPPER_JAR=%DIR%.mvn\wrapper\maven-wrapper.jar"
set "WRAPPER_PROPERTIES=%DIR%.mvn\wrapper\maven-wrapper.properties"
set "DEFAULT_WRAPPER_URL=https://repo.maven.apache.org/maven2/org/apache/maven/wrapper/maven-wrapper/3.2.0/maven-wrapper-3.2.0.jar"

if not exist "%DIR%.mvn\wrapper" (
  mkdir "%DIR%.mvn\wrapper" >nul 2>&1
)

if not exist "%WRAPPER_JAR%" (
  powershell -NoProfile -ExecutionPolicy Bypass -Command "$props = Get-Content -Raw '%WRAPPER_PROPERTIES%'; $url = ($props -split '\r?\n' | Where-Object { $_ -match '^wrapperUrl=' } | ForEach-Object { $_.Split('=')[1] }); if (-not $url -or [string]::IsNullOrWhiteSpace($url)) { $url = '%DEFAULT_WRAPPER_URL%' }; Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile '%WRAPPER_JAR%'"
  if errorlevel 1 exit /b %errorlevel%
)

if defined JAVA_HOME (
  set "JAVA_EXE=%JAVA_HOME%\bin\java.exe"
) else (
  set "JAVA_EXE=java"
)

set "MAVEN_PROJECTBASEDIR=%DIR%"
"%JAVA_EXE%" -Dmaven.multiModuleProjectDirectory=%MAVEN_PROJECTBASEDIR% -cp "%WRAPPER_JAR%" org.apache.maven.wrapper.MavenWrapperMain %*
exit /b %errorlevel%
