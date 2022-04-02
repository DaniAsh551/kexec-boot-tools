/**
 * Based on inspiration from:
 * https://edwardhalferty.com/2021/03/06/mounting-proc-sys-and-dev-in-an-init-process/
 * https://github.com/ubports/upstart/blob/xenial/init/main.c
 */
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mount.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>

int
system_mount (const char *type,
	      const char *dir,
	      unsigned long flags,
	      const char *options);
void print_kmsg(const char *msg);
void print_kmsgi(const char *msg, int i);
void print_kmsgs(const char *msg, const char *s);
void mount_proc();
void mount_sys();
void mount_dev();
void mount_tmp();
void mount_data();
void mount_system();
int file_exists(const char *path);
void run_init();

/**
 * @brief Print a message to /dev/kmsg
 * @param msg The message
 */
void print_kmsg(const char *msg) {
   FILE *kmsg;
   kmsg = fopen("/dev/kmsg", "w+");
   fprintf(kmsg, "%s", msg);
   fclose(kmsg);
}

/**
 * @brief Print a message to /dev/kmsg with an int at the end
 * @param msg The message
 * @param i The int
 */
void print_kmsgi(const char *msg, int i) {
   FILE *kmsg;
   kmsg = fopen("/dev/kmsg", "w+");
   fprintf(kmsg, "%s", msg);
   fprintf(kmsg, "%d\n", i);
   fclose(kmsg);
}

/**
 * @brief Print a message to /dev/kmsg with a string at the end
 * @param msg The message
 * @param s The string
 */
void print_kmsgs(const char *msg, const char *s) {
   FILE *kmsg;
   kmsg = fopen("/dev/kmsg", "w+");
   fprintf(kmsg, "%s", msg);
   fprintf(kmsg, "%s\n", s);
   fclose(kmsg);
}

/**
 * @brief Return if a file exists on the given path (checks if file exists and is readable)
 * @param path Path to file
 * @return int 1=exists 0=not exists or unreadable
 */
int file_exists(const char *path){
   FILE * file;
   file = fopen(path, "r");

   if(file != NULL){
      fclose(file);
      return 1;
   }else{
      return 0;
   }
}

/**
 * @brief Mount a given system partition.
 * @param type 
 * @param dir 
 * @param flags 
 * @param options 
 * @return int 1=SUCCESS 0=FAIL
 */
int system_mount (const char *type,
	      const char *dir,
	      unsigned long flags,
	      const char *options)
{
	/* Mount the filesystem */
	int status = mount("none", dir, type, flags, options);

	return status;
}

void mount_proc() {
   print_kmsg("[KBT] Mounting /proc...");
   if (system_mount ("proc", "/proc",
				  MS_NODEV | MS_NOEXEC | MS_NOSUID, NULL) < 0) {
      print_kmsg("[KBT] Failed to mount /proc!\n");
      exit(1);
   }
}
 
void mount_sys() {
   print_kmsg("[KBT] Mounting /sys...");

   if (system_mount ("sysfs", "/sys",
				  MS_NODEV | MS_NOEXEC | MS_NOSUID, NULL) < 0) {
      print_kmsg("[KBT] Failed to mount /sys!\n");
      exit(1);
   }
}

void mount_data() {
   print_kmsg("[KBT] Mounting /data...");

   if (mount ("/dev/sda31", "/data", "ext4",
				  MS_NODIRATIME | MS_NOATIME, NULL) < 0) {
      print_kmsg("[KBT] Failed to mount /data!\n");
      exit(1);
   }
}

void mount_system() {
   print_kmsg("[KBT] Mounting /system...");

   if (mount ("/dev/sda25", "/system", "ext4",
				  MS_NODIRATIME | MS_NOATIME, NULL) < 0) {
      print_kmsg("[KBT] Failed to mount /system!\n");
      exit(1);
   }
}
 
void mount_dev() {
   printf("[KBT] Mounting /dev...");

   if (system_mount ("devtmpfs", "/dev",
					  MS_NOEXEC | MS_NOSUID, NULL) < 0) {
      int errno2 = errno;
      // Error code 16 ("device or resource busy") is spurrious and doesn't really matter. Ignore it.
      if (errno2 != 16) {
        //printing the error code, but we won't see any errors sadly :(
         printf("[KBT] Failed to mount /dev! errno=%d strerror=%s\n", errno, strerror(errno));
         exit(1);
      }
   }

   //Not mounting /dev/pts yet (not sure if needed)
}

void mount_tmp() {
   print_kmsg("[KBT] Mounting /tmp...");

   if (system_mount ("tmpfs", "/tmp",
				  MS_NODEV | MS_NOEXEC | MS_NOSUID, NULL) < 0) {
      print_kmsg("[KBT] Failed to mount /tmp!\n");
      exit(1);
   }
}

/**
 * @brief The actual init code lives here. We load bash and execute the /init.sh where the rest of init is done.
 */
void run_init() {
   char *const argv[] = {
      "/bin/busybox",
      "ash",
      "/init.sh",
      NULL
   };

   int status = execvp(argv[0], argv);

   if(status == 0){
      print_kmsg("[KBT] BASH CALL EXITED WITH: 0");
   }else{
      print_kmsgi("[KBT] BASH CALL EXITED WITH:", status);
   }
}

int main() {
   mount_dev();
   print_kmsg("KEXEC_BOOT_TOOLS_START\n");
   // mount_sys();
   // mount_proc();
   // mount_data();
   // mount_system();
   run_init();
   return 0;
}