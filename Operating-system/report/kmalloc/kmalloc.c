#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/slab.h>

#define PRINT_PREF "[KMALLOC_TEST]: "

static int __init my_mod_init(void) {
    unsigned long i;
    void *ptr;

    printk(PRINT_PREF "Entering module.\n");
    for (i = 1;;i *= 2) {
        ptr = kmalloc(i, GFP_KERNEL);
        if (!ptr) {
            printk(PRINT_PREF "could not allocate %lu bytes.\n", i);
            break;
        }
        kfree(ptr);
    }
    return 0;
}

static void __exit my_mod_exit(void) {
    printk(KERN_INFO "Exiting module.\n");
}

module_init(my_mod_init);
module_exit(my_mod_exit);

MODULE_LICENSE("GPL");