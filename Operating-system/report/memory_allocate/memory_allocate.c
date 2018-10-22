#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/gfp.h>
#include <linux/highmem.h>

#define PRINT_PREF "[HIGHMEM]:"
#define INTS_IN_PAGE (PAGE_SIZE/sizeof(int))

static int __init my_mod_init(void) {
    struct page *my_page;
    void *my_ptr;
    int i, *int_array;

    printk(PRINT_PREF "Entering Module.\n");

    my_page = alloc_page(GFP_HIGHUSER);
    if (!my_page) return -1;

    my_ptr = kmap(my_page);
    int_array = (int *)my_ptr;
    for (i = 0; i < INTS_IN_PAGE; i++) {
        int_array[i] = i;
        printk(PRINT_PREF "array[%d] = %d\n", i, int_array[i]);
    }

    kunmap(my_page);
    __free_pages(my_page, 0);

    return 0;
}

static void __exit my_mod_exit(void) {
    printk(PRINT_PREF "Exiting module.\n");
}

module_init(my_mod_init);
module_exit(my_mod_exit);