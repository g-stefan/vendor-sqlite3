// Created by Grigore Stefan <g_stefan@yahoo.com>
// Public domain (Unlicense) <http://unlicense.org>
// SPDX-FileCopyrightText: 2022-2024 Grigore Stefan <g_stefan@yahoo.com>
// SPDX-License-Identifier: Unlicense

Fabricare.include("vendor");

messageAction("make");

if (!Shell.directoryExists("source")) {
	exitIf(Shell.system("7z x -aoa archive/" + Project.vendor + ".7z"));
	Shell.rename(Project.vendor, "source");
};

Shell.mkdirRecursivelyIfNotExists("output");
Shell.mkdirRecursivelyIfNotExists("output/bin");
Shell.mkdirRecursivelyIfNotExists("output/include");
Shell.mkdirRecursivelyIfNotExists("output/lib");
Shell.mkdirRecursivelyIfNotExists("temp");

Shell.mkdirRecursivelyIfNotExists("output/include");
Shell.copyFile("source/sqlite3.h", "output/include/sqlite3.h");
Shell.copyFile("source/sqlite3ext.h", "output/include/sqlite3ext.h");

global.xyoCCExtra = function () {
	arguments.push(

		"--inc=output/include",
		"--use-lib-path=output/lib",
		"--rc-inc=output/include",

		"--inc=" + pathRepository + "/include",
		"--use-lib-path=" + pathRepository + "/lib",
		"--rc-inc=" + pathRepository + "/include"

	);
	return arguments;
};

var compileProject = {
	"project": "libsqlite3",
	"includePath": [
		"output/include",
		"source",
	],
	"defines": [
		"SQLITE_ENABLE_FTS4",
		"SQLITE_ENABLE_RTREE",
		"SQLITE_ENABLE_COLUMN_METADATA",
		"SQLITE_ENABLE_FTS5"
	],
	"cSource": [
		"source/sqlite3.c"
	],
	"linkerDefinitionsFile": "fabricare/source/sqlite3.def"
};

Shell.filePutContents("temp/" + compileProject.project + ".compile.json", JSON.encodeWithIndentation(compileProject));
if (Fabricare.isStatic()) {
	exitIf(xyoCC.apply(null, xyoCCExtra("@temp/" + compileProject.project + ".compile.json", "--lib", "--output-lib-path=output/lib")));
};
if (Fabricare.isDynamic()) {
	exitIf(xyoCC.apply(null, xyoCCExtra("@temp/" + compileProject.project + ".compile.json", "--dll", "--output-bin-path=output/bin", "--output-lib-path=output/lib")));
};

var compileProject = {
	"project": "sqlite3",
	"includePath": ["output/include", "source"],
	"cSource": ["source/shell.c"],
	"library": ["libsqlite3"]
};

Shell.filePutContents("temp/" + compileProject.project + ".compile.json", JSON.encodeWithIndentation(compileProject));
exitIf(xyoCC.apply(null, xyoCCExtra("@temp/" + compileProject.project + ".compile.json", "--exe", "--output-bin-path=output/bin")));

if (OS.isWindows()) {
	exitIf(!Shell.copyFile("output/lib/libsqlite3.lib", "output/lib/sqlite3.lib"));
};

