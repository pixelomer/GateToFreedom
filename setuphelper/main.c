// You might be wondering: "Why is this written in C instead of Objective-C?"
// I don't really have a logical answer. I just wanted to write it like this.

#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

#define random_char() ((char)(arc4random_uniform('Z'-'A')+'A'))

#define ERROR_INVALID_ARGS 1
#define ERROR_IO_FAILURE 2
#define ERROR_UNKNOWN_USER 3
#define ERROR_CRYPT_FAILURE 4
#define ERROR_CORRUPTED_FILE 5
#define ERROR_SETUID_FAILURE 6

#define MASTER_PASSWD_PATH "/etc/master.passwd"

int main(int argc, char **argv) {
	if (setuid(0)) {
		return ERROR_SETUID_FAILURE;
	}
	if (argc <= 1);
	else if (!strcmp(argv[1], "-d")) {
		// Usage: setuphelper -d
		// - Makes setuphelper delete itself.

		return !!unlink(argv[0]);
	}
	else if (!strcmp(argv[1], "-c")) {
		// Usage: setuphelper -c <username> <newpass>
		// - Modifies /etc/master.passwd and changes the password for <username> to <newpass>

		// Check if enough arguments were given
		if (argc <= 3) return ERROR_INVALID_ARGS;

		// Open the master.passwd file for reading. This password contains user accounts and their hashed passwords.
		FILE *master_passwd = fopen(MASTER_PASSWD_PATH, "r");
		if (!master_passwd) return ERROR_IO_FAILURE;

		// Look for the target user's line
		long user_pos = 0;
		long rest_pos = 0;
		char *unmodified_line;
		size_t prefix_len;
		char *prefix;
		{
			char *line = NULL;
			size_t line_size = 0;
			char *username = argv[2];
			prefix_len = strlen(username)+1;
			prefix = malloc(prefix_len+1);
			sprintf(prefix, "%s:", username);
			_Bool did_find_line = 0;
			while (getline(&line, &line_size, master_passwd) != -1) {
				if (!strncmp(line, prefix, prefix_len)) {
					did_find_line = 1;
					break;
				}
				user_pos += strlen(line);
			}
			if (!did_find_line) return ERROR_UNKNOWN_USER;
			long user_line_len = strlen(line);
			rest_pos = user_pos + user_line_len;
			unmodified_line = malloc(user_line_len+1);
			strcpy(unmodified_line, line);
			free(line);
		}

		// Hash the new password
		char *new_hash;
		{
			char *new_pass = argv[3];
			char *salt = malloc(3);
			sprintf(salt, "%c%c", random_char(), random_char());
			new_hash = crypt(new_pass, salt);
			free(salt);
			if (!new_hash) return ERROR_CRYPT_FAILURE;
		}
		
		// Get the length of the old hash.
		long old_hash_len = 0;
		{
			for (char *tmp = unmodified_line + prefix_len; *tmp != ':'; tmp++) {
				old_hash_len++;
				if (*tmp == 0x0) {
					return ERROR_CORRUPTED_FILE;
				}
			}
		}

		// Create a new line with the new information using the collected information.
		char *new_user_line;
		long length_difference;
		{
			char *tmp = unmodified_line+prefix_len+old_hash_len;
			asprintf(&new_user_line, "%s%s%s", prefix, new_hash, tmp);
			length_difference = strlen(new_user_line) - strlen(unmodified_line);
		}

		// Create the new file in memory.
		char *new_file_contents;
		long new_file_len;
		{
			char *suffix;
			char *prefix;

			fseek(master_passwd, 0, SEEK_END);
			long file_len = ftell(master_passwd);
			new_file_len = (file_len - length_difference);
			new_file_contents = malloc(new_file_len+1);
			fseek(master_passwd, 0, SEEK_SET);
			prefix = malloc(user_pos+1);
			fread(prefix, 1, user_pos, master_passwd);
			prefix[user_pos] = 0;
			fseek(master_passwd, rest_pos, SEEK_SET);
			long suffix_len = file_len - rest_pos;
			suffix = malloc(suffix_len+1);
			fread(suffix, 1, suffix_len, master_passwd);
			suffix[suffix_len] = 0;

			sprintf(new_file_contents, "%s%s%s", prefix, new_user_line, suffix);
		}

		// Write the new contents to the file.
		fclose(master_passwd);
		master_passwd = fopen(MASTER_PASSWD_PATH, "w");
		fwrite(new_file_contents, 1, new_file_len, master_passwd);
		fclose(master_passwd);
		return 0;
	}
	return ERROR_INVALID_ARGS;
}
