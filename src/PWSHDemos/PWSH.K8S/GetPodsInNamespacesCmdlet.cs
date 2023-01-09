using System.Management.Automation;
using k8s;
using k8s.Models;

namespace PWSH.K8S;

[Cmdlet(VerbsCommon.Get, "NsPods")]
[OutputType(typeof(List<V1Pod>))]
public class GetPodsInNamespacesCmdlet : Cmdlet
{
    private readonly IKubernetes kubernetesClient;

    public GetPodsInNamespacesCmdlet()
    {
        var config = KubernetesClientConfiguration.BuildConfigFromConfigFile();
        kubernetesClient = new Kubernetes(config);
    }

    [Parameter(Position = 0,
        ValueFromPipeline = true,
        ValueFromPipelineByPropertyName = true,
        Mandatory = true)]
    [ValidateNotNullOrEmpty]
    public string? NamespaceName { get; set; }

    protected override void ProcessRecord()
    {
        if (string.IsNullOrEmpty(NamespaceName)) NamespaceName = "default";

        var podList = kubernetesClient.CoreV1.ListNamespacedPod(NamespaceName);
        WriteObject(podList.Items, true);
    }
}