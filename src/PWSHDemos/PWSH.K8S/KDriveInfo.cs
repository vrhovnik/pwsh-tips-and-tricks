using System.Management.Automation;
using k8s;

namespace PWSH.K8S;

public class KDriveInfo : PSDriveInfo
{
    public IKubernetes KubernetesInstance { get; set; }

    public KDriveInfo(PSDriveInfo driveInfo) : base(driveInfo)
    {
        var buildConfigFromConfigFile = KubernetesClientConfiguration.BuildConfigFromConfigFile();
        KubernetesInstance=new Kubernetes(buildConfigFromConfigFile);
    }
}