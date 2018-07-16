component extends="qb.models.Grammars.BaseGrammar" {

    /**
    * Parses and wraps a value from the Builder for use in a sql statement.
    *
    * @table The value to parse and wrap.
    *
    * @return string
    */
    function wrapValue( required any value ) {
        if ( value == "*" ) {
            return value;
        }
        return "`#value#`";
    }

    /**
    * Parses and wraps a value from the Builder for use in a sql statement.
    *
    * @table The value to parse and wrap.
    *
    * @return string
    */
    public string function wrapAlias( required any value ) {
        return """#value#""";
    }

    function compileRenameTable( blueprint, commandParameters ) {
        return arrayToList( arrayFilter( [
            "RENAME TABLE",
            wrapTable( blueprint.getTable() ),
            "TO",
            wrapTable( commandParameters.to )
        ], function( item ) {
            return item != "";
        } ), " " );
    }

    function compileTableExists( tableName ) {
        return "SELECT 1 FROM `information_schema`.`tables` WHERE `table_name` = ?";
    }

    function compileColumnExists( table, column ) {
        return "SELECT 1 FROM `information_schema`.`columns` WHERE `table_name` = ? AND `column_name` = ?";
    }

    function compileDropForeignKey( blueprint, commandParameters ) {
        return "ALTER TABLE #wrapTable( blueprint.getTable() )# DROP FOREIGN KEY #wrapValue( commandParameters.name )#";
    }

    function compileDropAllObjects( options ) {
        var tables = getAllTableNames( options );
        var tableList = arrayToList( arrayMap( tables, function( table ) {
            return wrapTable( table );
        } ), ", " );
        return arrayFilter( [
            compileDisableForeignKeyConstraints(),
            arrayIsEmpty( tables ) ? "" : "DROP TABLE #tableList#",
            compileEnableForeignKeyConstraints()
        ], function( sql ) { return sql != ""; } );
    }

    function getAllTableNames( options ) {
        var tablesQuery = runQuery( "SHOW FULL TABLES WHERE table_type = 'BASE TABLE'", {}, options, "query" );
        var columnName = arrayToList( arrayFilter( tablesQuery.getColumnNames(), function( columnName ) {
            return columnName != "Table_type";
        } ) );
        var tables = [];
        for ( var table in tablesQuery ) {
            arrayAppend( tables, table[ columnName ] );
        }
        return tables;
    }

    function compileDisableForeignKeyConstraints() {
        return "SET FOREIGN_KEY_CHECKS=0";
    }

    function compileEnableForeignKeyConstraints() {
        return "SET FOREIGN_KEY_CHECKS=1";
    }

    function generateDefault( column ) {
        if ( column.getDefault() == "" && column.getType() == "TIMESTAMP" ) {
            column.setDefault( "CURRENT_TIMESTAMP" );
        }
        return super.generateDefault( column );
    }

    function typeString( column ) {
        return "NVARCHAR(#column.getLength()#)";
    }

    function typeChar( column ) {
        return "NCHAR(#column.getLength()#)";
    }

}