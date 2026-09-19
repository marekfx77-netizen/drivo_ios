# SSH Mobile

A native iOS SSH client written in SwiftUI.

## Cloud build

Pushing to `main`, or running **Actions → Build iOS IPA → Run workflow**, builds an unsigned `SSHMobile.ipa` and makes it available in the workflow run's **Artifacts** section.

The unsigned IPA is useful for validating that the application compiles. It cannot be installed on a physical iPhone. To distribute it, configure Apple code-signing secrets and change the signing section of the workflow.
