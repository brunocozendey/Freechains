@ECHO OFF
SET var=%cd%
java -Xmx5M -Xms5M -ea -cp %var%\slf4j-nop-2.0.0-alpha1.jar;%var%\Freechains.jar org.freechains.host.MainKt %*
PAUSE