# Tools - IDE

## PhpStorm

### Config

#### Plugin

* Downloaded
  * PHP Annotations
  * Symfony Plugin
* Database
  * Database Tools and SQL
* HTML and XML
  * HTML Tools
* Javascript Frameworks and Tools
  * Javascript and TypeScript
  * Javascript Debugger
  * Javascript intention Power Pack
  * Nodejs
  * Prettier
* Languages
  * Ini
  * JSON
  * markdown
  * PHP
  * PHP Architecture
  * PHPT Support
  * Shell Script
  * YAML
* SpellChecker
  * Hunspell
* Style Sheet
  * CSS
* Template Languages
  * Twig
* Test Tools
  * PHPSpec BDD Framework
* Version Control
  * Git
* Other Tools
  * PHPStan Support
  * Psalm Support
  * Terminal

#### Settings

* Disable some configurations

```text
Settings / Appearance & Behavior / System Settings / Autosave / Sync external changes:


Settings / Appearance & Behavior / System Settings / HTTP Proxy
```

* Configure some configurations related Symfony Framework

```text
Settings / PHP / Symfony / Container:

HTTP Profiler - https://127.0.0.1:8080
```

```text
Settings / PHP / Symfony / Routing:

app/var/cache/dev/url_generating_routes.php
```

```text
Settings / PHP / Symfony / Profiler:

HTTP Profiler - https://127.0.0.1:8080
```

#### Menu / Help

* Edit Custom Properties

```text
idea.max.content.load.filesize=40000
idea.max.intellisense.filesize=10000
idea.cycle.buffer.size=2048

idea.max.vcs.loaded.size.kb=40960

idea.no.launcher=false
idea.dynamic.classpath=false

editor.zero.latency.typing=true
```

* Edit Custom VM Options

```text
#####################
# Default VM Options
#####################
# default value is 128m
-Xms1024m
# default value is 750m
-Xmx4096m
# default value is 512m
-XX:ReservedCodeCacheSize=1024M
-XX:+UseG1GC
# default value is 50
-XX:SoftRefLRUPolicyMSPerMB=250
# default value is 2
-XX:CICompilerCount=4
-XX:+HeapDumpOnOutOfMemoryError
-XX:-OmitStackTraceInFastThrow
-XX:+IgnoreUnrecognizedVMOptions
-XX:CompileCommand=exclude,com/intellij/openapi/vfs/impl/FilePartNodeRoot,trieDescend
-ea
-Dsun.io.useCanonCaches=false
-Dsun.java2d.metal=true
-Djbr.catch.SIGABRT=true
-Djdk.http.auth.tunneling.disabledSchemes=""
-Djdk.attach.allowAttachSelf=true
-Djdk.module.illegalAccess.silent=true
-Dkotlinx.coroutines.debug=off


##################################
# Improved Performance VM OPTIONS
##################################
-server
-Xss64m
-XX:+UseCompressedOops
-XX:NewRatio=2
-Dfile.encoding=UTF-8
-XX:+UseConcMarkSweepGC
-XX:NewSize=512m
-XX:MaxNewSize=512m
-XX:PermSize=512m
-XX:MaxPermSize=1024m
-XX:+UseParNewGC
-XX:ParallelGCThreads=4
-XX:MaxTenuringThreshold=1
-XX:SurvivorRatio=8
-XX:+UseCodeCacheFlushing
-XX:+AggressiveOpts
-XX:+CMSClassUnloadingEnabled
-XX:+CMSIncrementalMode
-XX:+CMSIncrementalPacing
-XX:+CMSParallelRemarkEnabled
-XX:CMSInitiatingOccupancyFraction=65
-XX:+CMSScavengeBeforeRemark
-XX:+UseCMSInitiatingOccupancyOnly
-XX:-TraceClassUnloading
-XX:+AlwaysPreTouch
-XX:+TieredCompilation
-XX:+DoEscapeAnalysis
-XX:+UnlockExperimentalVMOptions
-XX:LargePageSizeInBytes=256m
-XX:+DisableExplicitGC
-XX:+ExplicitGCInvokesConcurrent
-XX:+PrintGCDetails
-XX:+PrintFlagsFinal
-XX:+CMSPermGenSweepingEnabled
-XX:+UseAdaptiveGCBoundary
-XX:+UseSplitVerifier
-XX:CompileThreshold=10000
-XX:+UseCompressedStrings
-XX:+OptimizeStringConcat
-XX:+UseStringCache
-XX:+UseFastAccessorMethods
-XX:+UnlockDiagnosticVMOptions
-Xverify:none
-Djava.net.preferIPv4Stack=true

-XX:ErrorFile=$USER_HOME/java_error_in_idea_%p.log
-XX:HeapDumpPath=$USER_HOME/java_error_in_idea.hprof

##################################
# Enable The Following Option If
# You Want To Disable Updates OR
# Updates Are Managed By ToolBox
##################################
#-Dide.no.platform.update=true
```

## Reference

* IDE
  * [PhpStorm](https://www.jetbrains.com/phpstorm)
    * Settings
      * PHP
        * Xdebug - [Configuration](https://www.jetbrains.com/help/phpstorm/debugging-with-phpstorm-ultimate-guide.html)
      * Deployment - [Deploying application](https://www.jetbrains.com/help/phpstorm/deploying-applications.html)
      * [Symfony Framework](https://www.jetbrains.com/help/phpstorm/symfony-support.html#use_symfony_cli)
    * Plugin
      * draw.io - [Integration](https://plugins.jetbrains.com/plugin/15635-diagrams-net-integration)
