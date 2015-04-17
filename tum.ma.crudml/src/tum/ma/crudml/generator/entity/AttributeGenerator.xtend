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
import tum.ma.crudml.crudml.Annotation
import java.util.Arrays

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
		
		for (Entity e : entries){
			var hasPrimary = false
			var position = 10
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
				var name = e.name + CrudmlGenerator.primaryKeyPostfix
				generateMember(e, name, name, "long", position, true, Arrays.asList(), null)		
			}
				
			// create db tables 
			generateDatbaseTable(e)
		}
	}
	
		
	def private generateMember(Entity e, Member m, int memberPosition, boolean isPrimary){
		var displayName = GeneratorUtilities.getName(m.annotations)
		var primitive = m.primitive
		var name = m.name
		
		if (displayName.isNullOrEmpty){
			displayName = m.name
		}
		
		// Check if its an enum
		if (m.enumeration != null){
			primitive = "enum"
		}
		
		generateMember(e, name, displayName, primitive, memberPosition, isPrimary, m.annotations, m.enumeration)
	}
	
	def private generateMember(Entity e, String memberName, String displayName, String primitiveType, int memberPosition, boolean isPrimary, Iterable<Annotation> annotations, tum.ma.crudml.crudml.Enum enumeration){
		var tableType = ""
		var tableClass = ""
		var tablePostfix = ""
		var tableImport = ""
		var tableProperties = ""
		var smartFieldContent = ""
		var dbName = memberName
		var dbBindingName = memberName
		var tableWidth = 200;
		var imports = ""
		var name = memberName.toFirstUpper
		var entityName = e.name.toFirstUpper
		var tableHeader = displayName.toFirstUpper
		var stringLength = ""
		var notNullString = ""
		val notNull = GeneratorUtilities.notNull(annotations)
		
		val annotatedDisplayName = GeneratorUtilities.getName(annotations)
		if (!annotatedDisplayName.isNullOrEmpty){
			// remove starting and trailing " and '
			tableHeader = annotatedDisplayName
		}
		
		if (notNull) {
			notNullString = " NOT NULL"
		}
		
		switch primitiveType {
			case "string" : {
					stringLength = "(" + GeneratorUtilities.getLength(annotations) +")"
				}
		}
		
		tableType = GeneratorUtilities.getJavaTypeFromType(primitiveType)
		
		if (primitiveType.equals("enum")){
			tableClass = "Smart"
			tablePostfix = "<Long>"
			dbName += CrudmlGenerator.codeTypePostfix
			dbBindingName = memberName + "Code"
			var enumName = enumeration.name.toFirstUpper
			
			name += "Code"
			
			// getter for code type
			smartFieldContent = 
			'''
			@Override
			protected Class<? extends ICodeType<?, Long>> getConfiguredCodeType() {
				return «enumName»CodeType.class;
			}
			'''
			
			imports += 
			'''
			import org.eclipse.scout.rt.shared.services.common.code.ICodeType;
			import «CrudmlGenerator.applicationName».shared.codetypes.«enumName»CodeType;
			''';
		} else {
			tableClass = tableType
		}
		
		// database creation string
		if (!isPrimary){
			dbCreationString += dbName.toUpperCase + " " + GeneratorUtilities.getDBTypeFromType(primitiveType) + stringLength + notNullString + ", "
		} else {
			dbCreationString += dbName.toUpperCase + " " + GeneratorUtilities.getDBTypeFromType(primitiveType) + stringLength + notNullString + " GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), "
		}
		dbColumns += dbName.toUpperCase + ", "
		dbBindings += ":{page." + dbBindingName.toFirstLower + "}, "
		
		// create string for member name
		CrudmlGenerator.createStringEntry(tableHeader.replace(' ', ''), tableHeader, fsa)
		
		// add member to table page
		if (isPrimary){
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
        return TEXTS.get("«tableHeader.replace(' ', '').toFirstUpper»");
      }
         
      @Override
      protected int getConfiguredWidth() {
        return «tableWidth»;
      }
      
      @Override
      protected boolean getConfiguredMandatory() {
        return «notNull»;
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
    public class «name»Column extends Abstract«tableClass»Column«tablePostfix» {
«tableProperties»
«smartFieldContent»
    }
''')
		// imports
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.TablePage, entityName), Identifier.Imports, entityName,
'''	
import org.eclipse.scout.rt.client.ui.basic.table.columns.Abstract«tableClass»Column;
«imports»
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
		switch r.reftype {
			case "one" : generateMember(e, r.name + CrudmlGenerator.primaryKeyPostfix, r.name, "long", position, false, r.annotations, null)
			case "many" : { 
				// in this case we need a table to map the relation
				
				fsa.modifyLines(CrudmlGenerator.getFile(FileType.ServerSession), Identifier.DBSetupStatements,
'''	
		queries.add("DROP TABLE «e.name.toUpperCase»_«r.name.toUpperCase»");
		queries.add("CREATE TABLE «e.name.toUpperCase»_«r.name.toUpperCase» («e.name.toUpperCase + CrudmlGenerator.primaryKeyPostfix.toUpperCase» «GeneratorUtilities.getDBTypeFromType("long")» NOT NULL, «r.type.name.toUpperCase + CrudmlGenerator.primaryKeyPostfix.toUpperCase» «GeneratorUtilities.getDBTypeFromType("long")» NOT NULL)");
''')
			}
		}
	}
	
	def private generateDatbaseTable(Entity e){
		// create table
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.ServerSession), Identifier.DBSetupStatements,
'''	
      queries.add("CREATE TABLE «e.name.toUpperCase» («dbCreationString.substring(0, dbCreationString.length - 2)»)");
''')

		// sql statement for fetching data from database
		// Note that there are always members, at least the primary key one
		dbColumns = dbColumns.substring(0, dbColumns.length - 2)
		dbBindings = dbBindings.substring(0, dbBindings.length - 2)
		
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.StandardOutlineService), Identifier.SqlStatementGetTableData, e.name.toFirstUpper,
'''
statement.append(
        "SELECT «dbColumns»" +
        " FROM  «e.name.toUpperCase»" +
        " WHERE 1 = 1 ");
''') 	
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.StandardOutlineService), Identifier.SqlStatementGetTableDataInto, e.name.toFirstUpper,
'''
    statement.append("INTO «dbBindings»");
''') 	
	}
}