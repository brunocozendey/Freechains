@ECHO OFF
SET var=%cd%
java -Xmx5M -Xms5M -ea -cp %var%\Freechains.jar org.freechains.cli.MainKt %*
PAUSE