<?php

namespace Preseto\PHP_Multi_Linter;

function get_php_files( $directory ) {
	$php_files = [];

	foreach ( glob( $directory . '/*' ) as $file ) {
		if ( is_dir( $file ) ) {
			$php_files = array_merge( $php_files, get_php_files( $file ) );
		} elseif ( 'php' === pathinfo( $file, PATHINFO_EXTENSION ) ) {
			$php_files[] = $file;
		}
	}

	return $php_files;
}

function to_csv( $file, $data ) {
	$csv = fopen( $file, 'w' );

	foreach ( $data as $row ) {
		fputcsv( $csv, $row );
	}

	fclose( $csv );
}

// Get the target directory from the first argument or use the default.
$test_directory = $argv[1] ?? __DIR__ . '/code';

// Find all available PHP binaries.
$php_bins = array_filter( 
	glob( '/usr/bin/php*' ),
	fn( $file ) => is_file( $file ) && ! is_link( $file ) // Remove symlinked PHP binaries.
);

$php_files = get_php_files( $test_directory );

foreach ( $php_bins as $php_bin ) {
	$php_version = exec( "$php_bin -r 'echo PHP_VERSION;'" );
	
	$results = [];

	foreach ( $php_files as $php_file ) {
		$output = [];
		
		exec( "$php_bin -l $php_file 2>&1", $output, $return_code );

		$results[] = [
			'file' => $php_file,
			'return_code' => $return_code,
			'output' => implode( "\n", $output ),
		];

		printf( "%s = %s | %s\n", $php_version, $return_code, $php_file );
	}

	to_csv( sprintf( '%s/report-%s.csv', rtrim( $test_directory, '/\\' ), $php_version ), $results );
}

