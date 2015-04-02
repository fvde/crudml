package tum.ma.crudml.generator.entity

import tum.ma.crudml.generator.BaseGenerator
import org.eclipse.emf.ecore.resource.Resource
import tum.ma.crudml.generator.access.ExtendedFileSystemAccess
import tum.ma.crudml.crudml.Entity
import tum.ma.crudml.crudml.Attribute
import tum.ma.crudml.crudml.Member
import tum.ma.crudml.crudml.Reference
import tum.ma.crudml.generator.CrudmlGenerator
import tum.ma.crudml.generator.access.FileType
import tum.ma.crudml.generator.access.Identifier
import tum.ma.crudml.crudml.impl.MemberImpl
import tum.ma.crudml.generator.utilities.GeneratorUtilities

class AttributeGenerator extends BaseGenerator{
	
	private ExtendedFileSystemAccess fsa; 
	private String dbCreationString = ""
	private String primaryMemberName = ""
	private String dbColumns = ""
	private String dbBindings = ""
	
	new(int priority) {
		super(priority)
	}
	
	override doGenerate(Resource input, ExtendedFileSystemAccess fsa) {
		
		this.fsa = fsa
		
		// get entities
		val entries = input.allContents.toIterable.filter(Entity)
		var position = 10
		
		for (Entity e : entries){
			var hasPrimary = false
			dbCreationString = ""
			primaryMemberName = ""
			dbColumns = ""
			dbBindings = ""
			
			for (Attribute a : e.attributes){

				switch a {
					case (a instanceof Member) : generateMember(e, a as Member, position, false)
					case (a instanceof Reference) : generateReference(e, a as Reference, position)
				}
				
				position += 10;
			}
			
			// If no attribute was marked as primary we add a primary key column
			if (!hasPrimary){
				generateMember(e, e.name + "Nr", "long", position, true)		
			}
				
			// create db tables 
			generateDatbaseTable(e)
		}
	}
	
		
	def private generateMember(Entity e, Member m, int memberPosition, boolean isPrimary){
		generateMember(e, m.name, m.primitive, memberPosition, false)
	}
	
	def private generateMember(Entity e, String memberName, String primitiveType, int memberPosition, boolean isPrimary){
		var tableType = ""
		var tableImport = ""
		var tableProperties = ""
		var name = memberName.toFirstUpper
		var entityName = e.name.toFirstUpper
		var tableHeader = memberName.toFirstUpper
		var stringLength = ""
		
		switch primitiveType {
			case "string" : {
					tableType = "String"
					stringLength = "(100)"
				}
			case "int" : tableType = "Integer"
			case "long" : tableType = "Long"
			case "double" : tableType = "Double"
			case "boolean" : tableType = "Boolean"
		}
		
		// update database creation string
		//TODO add constraints like not null
		dbCreationString += memberName.toUpperCase + " " + GeneratorUtilities.getDBTypeFromType(primitiveType) + stringLength + " NOT NULL, "
		dbColumns += memberName.toUpperCase + ", "
		dbBindings += ":{" + memberName.toFirstLower + "}, "
		
		// create string for member name
		CrudmlGenerator.createStringEntry(tableHeader, fsa)
		
		// add member to table page
		if (isPrimary){
			primaryMemberName = memberName.toUpperCase
			
			tableProperties = 
'''
      @Override
      protected boolean getConfiguredDisplayable() {
        return false;
      }

      @Override
      protected boolean getConfiguredPrimaryKey() {
        return true;
      }
'''
		} else {
			tableProperties = 
'''

      @Override
      protected String getConfiguredHeaderText() {
        return TEXTS.get("«tableHeader»");
      }
'''
		}
		
		
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.TablePage, entityName), Identifier.TableContent, entityName, 
'''	

    /**
     * @return the «name»Column
     */
    public «name»Column get«name»Column() {
      return getColumnSet().getColumnByClass(«name»Column.class);
    }

    @Order(«memberPosition.toString».0)
    public class «name»Column extends Abstract«tableType»Column {
«tableProperties»
    }
''')
		// imports
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.TablePage, entityName), Identifier.Imports, entityName,
'''	
import org.eclipse.scout.rt.client.ui.basic.table.columns.Abstract«tableType»Column;
''')
		// add member to table page data
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.TablePageData, entityName), Identifier.Members, entityName,
'''	
	public static final String «name.toFirstLower» = "«name.toFirstLower»";
	private «tableType» m_«name.toFirstLower»;
''')

		fsa.modifyLines(CrudmlGenerator.getFile(FileType.TablePageData, entityName), Identifier.TableRowData, entityName,
'''	

    /**
     * @return the «name»
     */
    public «tableType» get«name»() {
      return m_«name.toFirstLower»;
    }

    /**
     * @param «name.toFirstLower»
     *          the «name» to set
     */
    public void set«name»(«tableType» «name.toFirstLower») {
      m_«name.toFirstLower» = «name.toFirstLower»;
    }
''')
	}
	
	def private generateReference(Entity e, Reference r, int position){
		
	}
	
	def private generateDatbaseTable(Entity e){
		// create table
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.ServerSession), Identifier.DBSetupStatements,
'''	
      queries.add("CREATE TABLE «e.name.toUpperCase» («dbCreationString»PRIMARY KEY(«primaryMemberName»))");
''')

		// sql statement for fetching data from database
		dbColumns = dbColumns.substring(0, dbColumns.length - 2)
		dbBindings = dbBindings.substring(0, dbBindings.length - 2)
		
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.StandardOutlineService), Identifier.SqlStatementGetTableData, e.name.toFirstUpper,
'''
SQL.selectInto("SELECT «dbColumns»" +
        " FROM  «e.name.toUpperCase»" +
        " INTO «dbBindings»",
        pageData);
''') 	
	}
}