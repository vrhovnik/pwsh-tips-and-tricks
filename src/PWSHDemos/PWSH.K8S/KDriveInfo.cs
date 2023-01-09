using System.Management.Automation;
using k8s;

namespace PWSH.K8S;

public class KDriveInfo : PSDriveInfo
{
    public IKubernetes KubernetesInstance { get; set; }

    public KDriveInfo(PSDriveInfo driveInfo) : base(driveInfo)
    {
    }

    public KDriveInfo(string name, ProviderInfo provider, string root, string description, PSCredential credential) : base(name, provider, root, description, credential)
    {
    }

    public KDriveInfo(string name, ProviderInfo provider, string root, string description, PSCredential credential, bool persist) : base(name, provider, root, description, credential, persist)
    {
    }

    public KDriveInfo(string name, ProviderInfo provider, string root, string description, PSCredential credential, string displayRoot) : base(name, provider, root, description, credential, displayRoot)
    {
    }
}