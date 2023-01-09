using System.Collections.ObjectModel;
using System.Management.Automation;
using System.Management.Automation.Provider;
using k8s;

namespace PWSH.K8S;

[CmdletProvider("KMan", ProviderCapabilities.None)]
public class KProvider : NavigationCmdletProvider
{
    private readonly IKubernetes kubernetesClient;

    public KProvider()
    {
        var config = KubernetesClientConfiguration.BuildConfigFromConfigFile();
        kubernetesClient = new Kubernetes(config);
    }

    private readonly char[] pathSeparators = { '/', '\\' };

    protected override bool IsValidPath(string path)
    {
        if (string.IsNullOrEmpty(path)) return false;

        return true;
    }

    protected override void GetItem(string path)
    {
        var allElts = path.Split(pathSeparators);

        if (allElts.Length > 1) return;

        // var list = kubernetesClient.CoreV1.ListNamespacedPod(allElts[0]);
        // WriteItemObject(list.Items, path, false);
        WriteItemObject(path, path, false);
    }

    protected override void GetChildItems(string path, bool recurse)
    {
        WriteItemObject(path, path, true);
        // var list = kubernetesClient.CoreV1.ListNamespacedPod(path);
        // WriteItemObject(list.Items, path, true);
    }

    protected override bool HasChildItems(string path)
    {
        return true;
//        if (path.Length == 0) return true;

        // var list = kubernetesClient.CoreV1.ListNamespacedPod(path);
        //
        // return list.Items.Count > 0;
    }

    protected override Collection<PSDriveInfo> InitializeDefaultDrives()
    {
        PSDriveInfo drive = new(
            name: "KMan",
            provider: ProviderInfo,
            root: @"\",
            "get pods in specific namespaces",
            credential: null);

        Collection<PSDriveInfo> drives = new() { drive };
        return drives;
    }
}