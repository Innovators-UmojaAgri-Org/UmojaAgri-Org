/*
  Warnings:

  - You are about to drop the column `ownerId` on the `Produce` table. All the data in the column will be lost.
  - Added the required column `farmerId` to the `Produce` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Produce" DROP CONSTRAINT "Produce_ownerId_fkey";

-- AlterTable
ALTER TABLE "Produce" DROP COLUMN "ownerId",
ADD COLUMN     "expiryDate" TIMESTAMP(3),
ADD COLUMN     "farmerId" TEXT NOT NULL,
ADD COLUMN     "harvestDate" TIMESTAMP(3),
ADD COLUMN     "unit" TEXT;

-- AddForeignKey
ALTER TABLE "Produce" ADD CONSTRAINT "Produce_farmerId_fkey" FOREIGN KEY ("farmerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
