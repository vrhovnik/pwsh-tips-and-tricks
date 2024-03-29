﻿using System.Collections.ObjectModel;
using System.Management.Automation;
using System.Management.Automation.Provider;
using k8s;

namespace PWSH.K8S;

[CmdletProvider("K8D", ProviderCapabilities.None)]
public class K8Drive : NavigationCmdletProvider
{
    protected override bool IsItemContainer(string path)
    {
        // Check if the path specified is a drive
        if (path.PathIsDrive(PSDriveInfo)) return true;

        var type = GetNamesFromPath(path, out var namespaceName, out _);

        if (type == PathTypes.Namespace)
        {
            var namespaceList = (PSDriveInfo as KDriveInfo)?.KubernetesInstance.CoreV1.ListNamespace();
            return namespaceList != null && namespaceList.Items.Any(namespaceListItem => namespaceListItem.Metadata.Name == namespaceName);
        }

        return false;
    } 

    protected override string GetChildName(string path)
    {
        if (path.PathIsDrive(PSDriveInfo)) return path;

        var type = GetNamesFromPath(path, out var namespaceName, out var podName);

        if (type == PathTypes.Namespace)
            return namespaceName;

        if (type == PathTypes.Pod)
            return podName;

        throw new ArgumentException("No data");
    }

    protected override Collection<PSDriveInfo> InitializeDefaultDrives()
    {
        PSDriveInfo drive = new(
            name: "K8D",
            provider: ProviderInfo,
            root: @"K8D:",
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
            throw new ArgumentNullException(nameof(drive));
        }

        // check if drive root is not null or empty
        if (string.IsNullOrEmpty(drive.Root))
        {
            WriteError(new ErrorRecord(new ArgumentException("drive.Root"), "NoRoot",
                ErrorCategory.InvalidArgument, drive));
            throw new ArgumentNullException(nameof(drive));
        }
        return new KDriveInfo(drive);
    } 

    protected override bool IsValidPath(string path) => 
        !string.IsNullOrEmpty(path);

    protected override void GetItem(string path)
    {
        var kDriveInfo = PSDriveInfo as KDriveInfo;
        if (path.PathIsDrive(PSDriveInfo))
        {
            var namespaceList = kDriveInfo?.KubernetesInstance.CoreV1.ListNamespace();
            var namespacesNames = namespaceList?.Items.Select(currentNamespace => currentNamespace.Metadata.Name);
            WriteItemObject(namespacesNames, path, true);
            return;
        } // if (PathIsDrive...

        var type = GetNamesFromPath(path, out var namespaceName, out var podName);

        if (type == PathTypes.Namespace)
        {
            var podList = kDriveInfo?.KubernetesInstance.CoreV1.ListNamespacedPod(namespaceName);
            var podNames = podList?.Items.Select(currentPod => currentPod.Metadata.Name);
            WriteItemObject(podNames, path + KProviderHelpers.PathSeparator, true);
        }
        else if (type == PathTypes.Pod)
        {
            var podList = kDriveInfo?.KubernetesInstance.CoreV1.ReadNamespacedPod(podName, namespaceName);
            WriteItemObject(podList?.Spec, path + KProviderHelpers.PathSeparator + podName, false);
        }
        else
            throw new ArgumentException("Data was not read clearly");
    }

    protected override void GetChildItems(string path, bool recurse)
    {
        // If path represented is a drive then the children in the path are 
        // namespaces. 
        var kDriveInfo = PSDriveInfo as KDriveInfo;
        if (path.PathIsDrive(PSDriveInfo))
        {
            var namespaceList = kDriveInfo?.KubernetesInstance.CoreV1.ListNamespace();
            var namespacesNames = namespaceList?.Items.Select(currentNamespace => currentNamespace.Metadata.Name);
            WriteItemObject(namespacesNames, path, true);
        } 
        else
        {
            var type = GetNamesFromPath(path, out var namespaceName, out var podName);

            if (type == PathTypes.Namespace)
            {
                var podList = kDriveInfo?.KubernetesInstance.CoreV1.ListNamespacedPod(namespaceName);
                var podNames = podList?.Items.Select(currentPod => currentPod.Metadata.Name);
                WriteItemObject(podNames, path + KProviderHelpers.PathSeparator, true);
            }
            else if (type == PathTypes.Pod)
            {
                var podList = kDriveInfo?.KubernetesInstance.CoreV1.ReadNamespacedPod(podName, namespaceName);
                WriteItemObject(podList?.Spec, path + KProviderHelpers.PathSeparator + podName, false);
            }
            else
                throw new ArgumentException("Data was not read clearly");
        } 
    } // GetChildItems
    
    protected override string GetParentPath(string path, string root)
    {
        if (string.IsNullOrEmpty(root))
            return path.Substring(0,
                path.LastIndexOf(KProviderHelpers.PathSeparator, StringComparison.OrdinalIgnoreCase));
        
        return (!path.Contains(root) ? null : path.Substring(0, path.LastIndexOf(KProviderHelpers.PathSeparator, StringComparison.OrdinalIgnoreCase))) 
               ?? string.Empty;
    }
    
    protected override void GetChildNames(string path, ReturnContainers returnContainers)
    {
        // If the path represented is a drive, then the child items are
        // namespaces
        var kDriveInfo = PSDriveInfo as KDriveInfo;
        if (path.PathIsDrive(PSDriveInfo))
        {
            var namespaceList = kDriveInfo?.KubernetesInstance.CoreV1.ListNamespace();
            var namespacesNames = namespaceList?.Items.Select(currentNamespace => currentNamespace.Metadata.Name);
            WriteItemObject(namespacesNames, path, true);
        } // if (PathIsDrive...
        else
        {
            var type = GetNamesFromPath(path, out var namespaceName, out var podName);

            if (type == PathTypes.Namespace)
            {
                var podList = kDriveInfo?.KubernetesInstance.CoreV1.ListNamespacedPod(namespaceName);
                var podNames = podList?.Items.Select(currentPod => currentPod.Metadata.Name);
                WriteItemObject(podNames, path, true);
            }
            else if (type == PathTypes.Pod)
            {
                var podList = kDriveInfo?.KubernetesInstance.CoreV1.ReadNamespacedPod(podName, namespaceName);
                WriteItemObject(podList?.Spec, path, false);
            }
            else
                throw new ArgumentException("Data was not read clearly");
        } // else
    } // GetChildNames

    protected override bool HasChildItems(string path)
    {
        if (path.PathIsDrive(PSDriveInfo)) return true;
        return path.ChunkPath(PSDriveInfo).Length == 1;
    }

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

    private PathTypes GetNamesFromPath(string path, out string namespaceName, out string podName)
    {
        var retVal = PathTypes.Invalid;
        namespaceName = "default";
        podName = string.Empty;

        // Check if the path specified is a drive
        if (path.PathIsDrive(PSDriveInfo)) return PathTypes.Cluster;

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
}