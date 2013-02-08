/**
 * @file
 *
 * @date 28.02.09
 * @author Eldar Abusalimov
 */

#include "screen.h"
#include <assert.h>
#include "console.h"
#include <drivers/diag.h>

#define FIRE_CALLBACK(cb, func, view, ...)	do {((cb->func != NULL) ? cb->func(cb, view, ## __VA_ARGS__) : 0) ;} while (0)

static void handle_char_token(SCREEN *this, TERMINAL_TOKEN ch) {
	SCREEN_CALLBACK *cb = this->callback;
	if (cb == NULL) {
		return;
	}

	FIRE_CALLBACK(cb, on_char, this, ch);
}

static void handle_ctrl_token(SCREEN *this, TERMINAL_TOKEN token,
		short *params, int params_len) {
	SCREEN_CALLBACK *cb = this->callback;
	static TERMINAL_TOKEN prev_token = TERMINAL_TOKEN_EMPTY;
	if (cb == NULL) {
		return;
	}

	switch (token) {
	case TERMINAL_TOKEN_CURSOR_LEFT:
		FIRE_CALLBACK(cb, on_cursor_left, this, 1);
		break;
	case TERMINAL_TOKEN_CURSOR_RIGHT:
		FIRE_CALLBACK(cb, on_cursor_right, this, 1);
		break;
	case TERMINAL_TOKEN_CURSOR_UP:
		FIRE_CALLBACK(cb, on_cursor_up, this, 1);
		break;
	case TERMINAL_TOKEN_CURSOR_DOWN:
		FIRE_CALLBACK(cb, on_cursor_down, this, 1);
		break;
	case TERMINAL_TOKEN_BS:
		FIRE_CALLBACK(cb, on_backspace, this, 0);
		break;
	case TERMINAL_TOKEN_DEL:
		FIRE_CALLBACK(cb, on_delete, this, 0);
		break;
	case TERMINAL_TOKEN_END:
		/* TODO: strange char 'F' */
		FIRE_CALLBACK(cb, on_end, this, 0);
		break;
	case TERMINAL_TOKEN_ETX:
		FIRE_CALLBACK(cb, on_etx, this, 0);
		break;
	case TERMINAL_TOKEN_EOT:
		FIRE_CALLBACK(cb, on_eot, this, 0);
		break;
	case TERMINAL_TOKEN_DC2:
		FIRE_CALLBACK(cb, on_dc2, this, 0);
		break;
	case TERMINAL_TOKEN_DC4:
		FIRE_CALLBACK(cb, on_dc4, this, 0);
		break;
	case TERMINAL_TOKEN_ACK:
		FIRE_CALLBACK(cb, on_ack, this, 0);
		break;
	case TERMINAL_TOKEN_LF:
		if (prev_token == TERMINAL_TOKEN_CR) {
			break;
		}
		/* FALLTHROUGH */
	case TERMINAL_TOKEN_CR:
		FIRE_CALLBACK(cb, on_new_line, this, 0);
		break;
	case TERMINAL_TOKEN_PRIVATE:
		if (params_len == 0) {
			break;
		}
		switch (params[0]) {
		case TERMINAL_TOKEN_PARAM_PRIVATE_DELETE:
			FIRE_CALLBACK(cb, on_delete, this, 0);
			break;
#if 0
		case TERMINAL_TOKEN_PARAM_PRIVATE_END:
			FIRE_CALLBACK(cb, on_end, this);
			break;
#endif
		case TERMINAL_TOKEN_PARAM_PRIVATE_HOME:
			FIRE_CALLBACK(cb, on_home, this, 0);
			break;
		case TERMINAL_TOKEN_PARAM_PRIVATE_INSERT:
			FIRE_CALLBACK(cb, on_insert, this, 0);
			break;
		default:
			break;
		}
		break;
	case TERMINAL_TOKEN_HT:
		FIRE_CALLBACK(cb, on_tab, this, 0);
		break;
	default:
		break;
	}

	prev_token = token;
}


void screen_in_start(SCREEN *this, SCREEN_CALLBACK *cb) {
	static TERMINAL_TOKEN token;
	short *params;
	int params_len;
	char ch;

	if ((this == NULL) || this->running) {
		return;
	}
	this->running = true;

	this->callback = cb;

	while (this->callback != NULL && terminal_receive(this->terminal, &token,
			&params, &params_len)) {
		ch = token & 0xFF;
		if (ch == token) {
			handle_char_token(this, token);
		} else {
			handle_ctrl_token(this, token, params, params_len);
		}
	}

	assert(this->callback == NULL);
	this->running = false;
}

void screen_in_stop(SCREEN *this) {
	if (this == NULL) {
		return;
	}

	this->callback = NULL;
}
