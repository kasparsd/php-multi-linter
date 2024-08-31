<?php

class Test {
	private function save_handlers() {
		session_set_save_handler( 'my_session_open', 'my_session_close', 'my_session_read', 'my_session_write', 'my_session_destroy', 'my_session_gc' );
	}
	public function imap() {
		imap_open( '{localhost/pop3:110}INBOX', '#username#', '#password#' ); 
	}
}