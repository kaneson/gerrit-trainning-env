import com.google.gerrit.sshd.SshCommand
import com.google.gerrit.extensions.annotations.Export
import com.google.gerrit.extensions.api.GerritApi
import com.google.gerrit.extensions.api.changes.ReviewInput

import com.google.inject.Inject
import org.kohsuke.args4j.Argument

@Export("dislike")
class GroovyCommand extends SshCommand {
    @Inject
    GerritApi gApi
    @Argument(usage = "change", metaVar = "CHANGE")
    String change

    public void run() {
        stdout.println("Disliking on change: " + change)
        gApi
            .changes()
            .id(change)
            .current()
            .review(new ReviewInput().dislike())
    }
}