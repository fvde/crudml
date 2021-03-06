package org.eclipselabs.scwork.template.generator.server

import org.eclipselabs.scwork.template.InputParam
import org.eclipselabs.scwork.template.generator.ITextFileGenerator

import static extension org.eclipselabs.scwork.template.generator.common.GeneratorExtensions.*
import tum.ma.crudml.generator.access.Identifier
import tum.ma.crudml.generator.utilities.GeneratorUtilities

class ServerSessionJavaGenerator implements ITextFileGenerator {
	
	override shouldGenerate(InputParam param) {
		param.serverIncluded
	}
	
	override provideFile(InputParam param) {
		param.serverSourceFile(#["ServerSession.java"])
	}
	
	override provideContent(InputParam param) 
'''
«param.copyrightHeader»
package «param.serverProjectName»;

import org.eclipse.scout.commons.exception.ProcessingException;
import org.eclipse.scout.commons.logger.IScoutLogger;
import org.eclipse.scout.commons.logger.ScoutLogManager;
import org.eclipse.scout.rt.server.AbstractServerSession;
import org.eclipse.scout.rt.server.ServerJob;
«GeneratorUtilities.createMarker(Identifier.Imports)»

public class ServerSession extends AbstractServerSession {
  private static final long serialVersionUID = 1L;
  private static boolean databaseDroppedAndCreated = false;
  private static IScoutLogger logger = ScoutLogManager.getLogger(ServerSession.class);

  public ServerSession() {
    super(true);
  }

  /**
   * @return session in current ThreadContext
   */
  public static ServerSession get() {
    return ServerJob.getCurrentSession(ServerSession.class);
  }

  @Override
  protected void execLoadSession() throws ProcessingException {
    logger.info("created a new session for " + getUserId());
«GeneratorUtilities.createMarker(Identifier.ExecLoadSession)»  }
}
'''
}
