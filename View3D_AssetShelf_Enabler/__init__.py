from __future__ import annotations

bl_info = {
    "name": "3D Viewport Asset Shelf Enabler",
    "author": "holoccha",
    "version": (1, 0, 2),
    "blender": (4, 5, 0),
    "location": "3D Viewport",
    "description": "Enables a generic asset shelf in the 3D Viewport",
    "category": "3D View",
}

import bpy


class VIEW3D_AST_asset_shelf_enabler(bpy.types.AssetShelf):
    bl_space_type = "VIEW_3D"
    bl_idname = "VIEW3D_AST_asset_shelf_enabler"
    bl_label = "Assets"
    bl_default_preview_size = 96

    @classmethod
    def poll(cls, context):
        return getattr(context, "mode", None) == "OBJECT"

    @classmethod
    def asset_poll(cls, asset):
        return asset.id_type in {"OBJECT", "COLLECTION", "MATERIAL"}


classes = (
    VIEW3D_AST_asset_shelf_enabler,
)


def register():
    for cls in classes:
        bpy.utils.register_class(cls)


def unregister():
    for cls in reversed(classes):
        bpy.utils.unregister_class(cls)
