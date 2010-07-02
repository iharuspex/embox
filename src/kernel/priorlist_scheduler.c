/**
 * @file
 * @brief Implementation of methods in scheduler.h
 *
 * @date 22.04.2010
 * @author Avdyukhin Dmitry
 * @author Darya Dzendzik
 */

#include <errno.h>
#include <stdlib.h>
#include <lib/list.h>

#include <kernel/scheduler.h>
#include <kernel/timer.h>
#include <hal/context.h>
#include <hal/ipl.h>
#include <embox/unit.h>

/** Timer, which calls scheduler_tick. */
#define THREADS_TIMER_ID 17

/** Interval, what scheduler_tick is called in. */
#define THREADS_TIMER_INTERVAL 100

/**
 * If it doesn't equal to zero,
 * we are located in critical section
 * and can't switch between threads.
 */

/*My comment
 typedef struct thread1 {
 int id;
 } thread_t;


 struct thread1 {
 int id;
 };

 typedref struct thread1 thread_t;*/

/**
 * structure thread in structure priority
 */
typedef struct thread_head {
	struct list_head *next;
	struct list_head *prev;
	struct thread *thr;
} thread_head_t;

/**
 * structure priority in list
 */
typedef struct priority_head {
	struct list_head *next;
	struct list_head *prev;
	int priority_id;
	thread_head_t *thread_list;
} priority_head_t;

/**
 * define max priority 16
 * idle thread has priority = 0
 * define max number thread 16
 */
#define MAX_PRIORITY 0x10
#define THREAD_PRIOR6ITY_IDLE 0
#define NUMBER_THREAD 2 //0x10
/**
 * Pools for thread and priority
 */
static priority_head_t priority_pool[MAX_PRIORITY];
/*head of priority list - null priority, next - max priority*/
#define priority_head          (&priority_pool[0])
static priority_head_t *cur_prior;

static thread_head_t thread_head_pool[NUMBER_THREAD];

struct list_head *free_threads_list;

/**
 * allocation head of thread in memory
 * free_thresd_list - pool
 * TODO: memory from pool!!!!!
 * MUST:
 * 1. alloc memory from pool
 * 2. made structure
 */
static thread_head_t *alloc_thread_head(thread_t *thr) {
	thread_head_t *head;
	if (list_empty(free_threads_list)) {
		return NULL;
	}
	head = (thread_head_t *) free_threads_list->next;
	list_del((struct list_head *) free_threads_list->next);
	head->thr = thr;
	return head;

}

static priority_head_t * alloc_priority(int priority) {
	return (&priority_pool[priority]);
}

/**
 * add head of thread
 */
static void free_thread_head(thread_head_t *head) {
	list_add((struct list_head *) head, free_threads_list);
}

/**
 * it's need for blocking
 */
static int preemption_count = 1;

/**
 *adding new priority structure to priority list
 *we mast:
 *1. allocation memory
 *2. add priority
 *3. sort
 */
static void add_new_priority(thread_head_t *thr_head, int priority) {
	/*allocate new  priority header*/
	priority_head_t *new_priority = alloc_priority(priority);
	priority_head_t *current_pr = (priority_head_t *) priority_head->next;
	priority_head_t *tmp;
	while (current_pr->priority_id > priority)
		current_pr = (priority_head_t *) current_pr->next;

	tmp = (priority_head_t *) current_pr->next;
	new_priority->next = (struct list_head *) tmp;
	new_priority->prev = (struct list_head *) current_pr;
	tmp->prev = (struct list_head *) new_priority;
	current_pr->next = (struct list_head *) new_priority;

	new_priority->priority_id = priority;
	new_priority->thread_list = thr_head;
	//new_priority->thread_list->thr->id = thr_head->thr
	return;

	/*set pointer to first thread header*/
}

/**
 * get list by priority
 */
static thread_head_t * get_list_by_priority(int priority) {
	struct list_head *p;

	if (idle_thread->priority == priority) { // TREAD_PRIORITY_IDLE -> idle_thread
		return priority_head->thread_list;
	}
	list_for_each(p, (struct list_head *)priority_head) {
		if (((priority_head_t *) p)->priority_id == priority) {
			return ((priority_head_t *) p)->thread_list;
		}
	}
	return NULL;
}

/**
 *adding thread with priority to thread list
 *or adding priority to priority list and thread to thread list
 */
static void add_thread_by_priority(struct thread*thr, int priority) {
	thread_head_t *list_head;
	thread_head_t *thr_head;
	/*check - is priority?*/
	if (NULL == (thr_head = alloc_thread_head(thr))) {
		return; //empty
	}

	if (NULL == (list_head = get_list_by_priority(priority))) {
		/*adding first thread that priority to list*/
		add_new_priority(thr_head, priority);
		return;// No, add new priority
	}
	list_add((struct list_head *) thr_head, (struct list_head *) list_head); //Yes
}

/** List item, pointing at begin of the list. */
static struct list_head *list_begin;
#define IDLE_PRIORITY = 0
/**
 * filling list of priority
 */
int scheduler_init(void) {
	/*
	 * initialization of free head pool
	 */
	free_threads_list = (thread_head_t *) thread_head_pool; //point to first element of array
	thread_head_t *p_thread_head = free_threads_list;
	for (int i = 0; i < NUMBER_THREAD; i++) {
		p_thread_head->prev = (struct list_head *) (p_thread_head - 1);
		p_thread_head->next = (struct list_head *) (++p_thread_head);
	}
	free_threads_list->prev = (--p_thread_head);
	p_thread_head->next = free_threads_list;

	/*we initialize zero element we always have idle_thread */
	priority_head_t *idle_priority = alloc_priority(idle_thread->priority);
	idle_priority->thread_list = (thread_head_t *) free_threads_list->next;
	list_del((struct list_head *) free_threads_list->next);
	idle_priority->next = (struct list_head *) idle_priority;
	idle_priority->prev = (struct list_head *) idle_priority;
	idle_priority->thread_list = (thread_head_t *)idle_thread;

	/*priority_pool[0].priority_id = 0; // TREAD_PRIORITY_IDLE -> idle_thread
	priority_pool[0].thread_list = idle_thread;*/
	current_thread = idle_thread;

	current_thread->reschedule = false;
	return (0);
}

/**
 * Is regularly called to show that current thread to be changed.
 * @param id nothing significant
 */
static void scheduler_tick(uint32_t id) {
	TRACE("\nTick\n");
	current_thread->reschedule = true;
}
/**
 * I think here scheduler start to work
 * I think it work's right
 */
void scheduler_start(void) {

	/* Redundant thread, which will never work. */
	struct thread redundant_thread;

	TRACE("\nStart scheduler\n");
	list_for_each_entry(current_thread, priority_head, sched_list) {
		TRACE("%d ", current_thread->id);
	}
	set_timer(THREADS_TIMER_ID, THREADS_TIMER_INTERVAL, scheduler_tick);

	ipl_disable();
	preemption_count--;
	context_switch(&redundant_thread.context, &idle_thread->context);
	/* NOTREACHED */
}

/**
 * blocking
 */
void scheduler_lock(void) {
	preemption_count++;
}

/**
 * unblocking
 */
void scheduler_unlock(void) {
	preemption_count--;
	if (preemption_count == 0 && current_thread->reschedule) {
		scheduler_dispatch();
	}
}

/**
 * Move current_thread pointer to the next thread.
 * @param prev_thread thread, which have worked just now.
 */

static void thread_move_next(struct thread *prev_thread) {
	//free current thread
	cur_prior->thread_list = cur_prior->thread_list->next;

	cur_prior = ((priority_head_t *) (priority_head->next));
	current_thread = ((priority_head_t *) (priority_head->next))->thread_list;

	if (current_thread->state == THREAD_STATE_ZOMBIE) {
		list_del(&current_thread->sched_list);
		current_thread
				= list_entry(prev_thread->sched_list.next, struct thread, sched_list);
	}
	current_thread->reschedule = false;
}

/**
 * main function - switch thread
 */
void scheduler_dispatch(void) {
	/* Thread, which have worked just now. */

	struct thread *prev_thread;
	ipl_t ipl;

	if (preemption_count == 0 && current_thread->reschedule) {
		preemption_count++;
		thread_move_next(current_thread);
		TRACE("Switching from %d to %d\n", prev_thread->id, current_thread->id);
		ipl = ipl_save();
		preemption_count--;
		context_switch(&prev_thread->context, &current_thread->context);
		ipl_restore(ipl);
	}
}

void scheduler_add(struct thread *added_thread) {
	add_thread_by_priority(added_thread, added_thread->priority);
}

/**
 * TODO watch...
 */
int scheduler_remove(struct thread *removed_thread) {
	if (removed_thread == NULL || removed_thread == idle_thread) {
		return -EINVAL;
	}
	scheduler_lock();
	removed_thread->reschedule = true;
	//free_thread_head(removed_thread);
	scheduler_unlock();
	return 0;
}
