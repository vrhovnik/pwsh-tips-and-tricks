using System.Collections.ObjectModel;
using System.Management.Automation;
using System.Management.Automation.Provider;
using k8s;

namespace PWSH.K8S;

[CmdletProvider("KMan", ProviderCapabilities.ShouldProcess)]
public class KProvider : ItemCmdletProvider
{
    protected override Collection<PSDriveInfo> InitializeDefaultDrives()
    {
        PSDriveInfo drive = new(
            name: "KMan",
            provider: ProviderInfo,
            root: @"\",
            "get namespaces and pods from current AKS cluster",
            credential: null);
        Collection<PSDriveInfo> drives = new() { drive };
        return drives;
    }
    
    protected override PSDriveInfo NewDrive(PSDriveInfo drive)
    {
        if (drive == null)
        {
            WriteError(new ErrorRecord(new ArgumentNullException(nameof(drive)),
                "NullDrive", ErrorCategory.InvalidArgument, null));
            return null;
        }

        // check if drive root is not null or empty
        if (string.IsNullOrEmpty(drive.Root))
        {
            WriteError(new ErrorRecord(new ArgumentException("drive.Root"), "NoRoot",
                ErrorCategory.InvalidArgument, drive));
            return null;
        }

        // create a new drive and create connection to kubernetes cluster
        var kubernetesPsDrive = new KDriveInfo(drive);
        var config = KubernetesClientConfiguration.BuildConfigFromConfigFile();
        kubernetesPsDrive.KubernetesInstance = new Kubernetes(config);
        return kubernetesPsDrive;
    } // NewDrive

    protected override void GetItem(string path)
    {
        var kDriveInfo = PSDriveInfo as KDriveInfo;
        if (path.PathIsDrive(PSDriveInfo))
        {
            var namespaceList = kDriveInfo.KubernetesInstance.CoreV1.ListNamespace();
            WriteItemObject(namespaceList.Items, path, true);
            return;
        } // if (PathIsDrive...

        var type = GetNamesFromPath(path, out var namespaceName, out var podName);

        if (type == PathTypes.Namespace)
        {
            var podList = kDriveInfo.KubernetesInstance.CoreV1.ListNamespacedPod(namespaceName);
            WriteItemObject(podList, path, true);
        }
        else if (type == PathTypes.Pod)
        {
            var podList = kDriveInfo.KubernetesInstance.CoreV1.ReadNamespacedPod(podName, namespaceName);
            WriteItemObject(podList.Spec, path, false);
        }
        else
            throw new ArgumentException("Data was not read clearly");
    }

    /// <summary>
    /// Test to see if the specified item exists.
    /// </summary>
    /// <param name="path">The path to the item to verify.</param>
    /// <returns>True if the item is found.</returns>
    protected override bool ItemExists(string path)
    {
        // check if the path represented is a drive
        if (path.PathIsDrive(PSDriveInfo)) return true;

        // Obtain type, namespace name and podname from path
        var type = GetNamesFromPath(path, out var namespaceName, out var podname);

        return type switch
        {
            PathTypes.Pod => !string.IsNullOrEmpty(namespaceName) && !string.IsNullOrEmpty(podname),
            PathTypes.Namespace => !string.IsNullOrEmpty(namespaceName),
            _ => false
        };
    } // ItemExists

    /// <summary>
    /// Chunks the path and returns the table name and the row number 
    /// from the path
    /// </summary>
    /// <param name="path">Path to chunk and obtain information</param>
    /// <param name="namespaceName">Name of the table as represented in the 
    /// path</param>
    /// <param name="podName">Row number obtained from the path</param>
    /// <returns>what the path represents</returns>
    private PathTypes GetNamesFromPath(string path, out string namespaceName, out string podName)
    {
        var retVal = PathTypes.Invalid;
        namespaceName = "default";
        podName = string.Empty;

        // Check if the path specified is a drive
        if (path.PathIsDrive(PSDriveInfo)) return PathTypes.Cluster;

        // chunk the path into parts
        var pathChunks = path.ChunkPath(PSDriveInfo);

        switch (pathChunks.Length)
        {
            case 1:
            {
                var name = pathChunks[0];
                namespaceName = name;
                retVal = PathTypes.Namespace;
                break;
            }
            case 2:
            {
                var name = pathChunks[0];
                namespaceName = name;
                podName = pathChunks[1];
                retVal = PathTypes.Pod;
                break;
            }
            default:
            {
                WriteError(new ErrorRecord(
                    new ArgumentException("The path supplied has too many segments"),
                    "PathNotValid",
                    ErrorCategory.InvalidArgument,
                    path));
                break;
            }
        } // switch(pathChunks...

        return retVal;
    } // GetNamesFromPath

    protected override bool IsValidPath(string path)
    {
        var result = !string.IsNullOrEmpty(path);

        // convert all separators in the path to a uniform one
        path = path.NormalizePath();

        // split the path into individual chunks
        var pathChunks = path.Split(KProviderHelpers.PathSeparator.ToCharArray());

        foreach (var pathChunk in pathChunks)
        {
            if (pathChunk.Length == 0) result = false;
        }

        return result;
    }
}