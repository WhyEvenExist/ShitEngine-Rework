package;

import sys.io.File;

using StringTools;

class ConsoleInterpreter
{
	/**
	 * Variable map.
	 */
	public static var variables:Map<String, Dynamic> = new Map<String, Dynamic>();

	/**
	 * Thank you mr bit of trolling for code lul
	 * @param command What command to send to the interpreter.
	 */
	public static function command(command:String)
	{
		var parsed:Array<String> = command.split("\n");
		for (i in 0...parsed.length)
		{
			switch (parsed[i].split(" ")[0])
			{
				case 'print':
					Sys.println(parsed[i].split('"')[1]);
				case 'write':
					File.saveContent(parsed[i].split(' ')[1], parsed[i].split(' ')[2]);
				case 'cl_set':
					variables.set(parsed[i].split(' ')[1], parsed[i].split(' ')[2]);
				case 'cl_get':
					variables.get(parsed[i].split(' ')[1]);
			}
		}
	}
}
