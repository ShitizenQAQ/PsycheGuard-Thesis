I will implement the "Scale Selection/Enabling" feature as follows:

### Backend Implementation
1.  **Update Entity (`PsychScale.java`)**: Add a `Boolean isEnabled` field (defaulting to `true`).
2.  **Update Controller (`PsychScaleController.java`)**: 
    *   Update `create` and `update` endpoints to accept and save the `isEnabled` status.
3.  **Update Data Seed (`data.sql`)**: Ensure the default "PCL-R" scale is enabled by default in the database initialization script.

### Frontend Implementation
1.  **Scale Management (`ScaleConfig.vue`)**:
    *   Add an **"Enable/Disable" Switch** (Checkbox) to each scale card header.
    *   When toggled, it will immediately call the backend API to update the status.
    *   Visual cue: Gray out disabled scales.
2.  **Assessment Page (`Assessment.vue`)**:
    *   Update the logic to **filter the list of scales**.
    *   Only scales with `isEnabled === true` will be shown in the dropdown for prisoners (or doctors).

This ensures that you can create draft scales without them appearing in the live assessment system until you explicitly "check" them.